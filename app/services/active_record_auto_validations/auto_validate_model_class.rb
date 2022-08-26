class ActiveRecordAutoValidations::AutoValidateModelClass
  attr_reader :model_class

  def self.execute!(model_class:)
    ActiveRecordAutoValidations::AutoValidateModelClass.new(model_class: model_class).perform
  end

  def initialize(model_class:)
    @model_class = model_class
  end

  def perform
    check_if_already_loaded_on_model_class!
    register_loaded_on_model_class!

    begin
      columns
      indexes
    rescue ActiveRecord::StatementInvalid => e
      # Database is probably not running - we need to ignore this to make stuff like db:migrate, db:schema:load work
      Rails.logger.error "AutoValidate: Ignoring error while loading columns, because database might not be initialized: #{e.message}"
      return
    end

    insert_active_record_auto_validations_from_columns!
    insert_active_record_auto_validations_from_indexes!
  end

  def check_if_already_loaded_on_model_class!
    auto_validations_loaded = model_class.instance_variable_get(:@_active_record_auto_validations_loaded)

    raise "AutoValidations already loaded for #{model_class.name}" if auto_validations_loaded
  end

  def register_loaded_on_model_class!
    model_class.instance_variable_set(:@_active_record_auto_validations_loaded, true)
  end

  def columns
    @columns ||= model_class.columns
  end

  def indexes
    @indexes ||= model_class.connection.indexes(model_class.table_name)
  end

  def insert_active_record_auto_validations_from_columns!
    columns.each do |column|
      next if column.name == "id" || column.name == "created_at" || column.name == "updated_at"

      auto_validate_pesence_on_column!(column) if auto_validate_presence_on_column?(column)
      auto_validate_max_length_on_column!(column) if auto_validate_max_length_on_column?(column)
    end
  end

  def insert_active_record_auto_validations_from_indexes!
    indexes.each do |index|
      ActiveRecordAutoValidations::AutoUniqueIndex.execute!(columns: columns, model_class: model_class, index: index) if index.unique
    end
  end

  def presence_validation_exists_on_column?(column)
    model_class.validators_on(column.name.to_sym).each do |validator|
      return true if validator.kind == :presence
    end

    false
  end

  def auto_validate_presence_on_column?(column)
    !column.null && !column.name.end_with?("_id") && column.default.nil? && !presence_validation_exists_on_column?(column)
  end

  def auto_validate_pesence_on_column!(column)
    Rails.logger.info "AutoValidate: Adding presence validation to #{model_class.table_name}##{column.name}"
    model_class.validates column.name.to_sym, presence: true
  end

  def auto_validate_max_length_on_column?(column)
    column.type == :string && column.limit && !max_length_validation_exists_on_column?(column)
  end

  def auto_validate_max_length_on_column!(column)
    Rails.logger.info "AutoValidate: Adding maxlength of #{column.limit} validation to #{model_class.table_name}##{column.name}"
    model_class.validates column.name.to_sym, allow_blank: true, length: {maximum: column.limit}
  end

  def max_length_validation_exists_on_column?(column)
    model_class.validators_on(column.name.to_sym).each do |validator|
      return true if validator.kind == :length
    end

    false
  end
end
