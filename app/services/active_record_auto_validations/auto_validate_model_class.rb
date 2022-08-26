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
    rescue ActiveRecord::StatementInvalid => e
      # Database is probably not running - we need to ignore this to make stuff like db:migrate, db:schema:load work
      Rails.logger.error "AutoValidate: Ignoring error while loading columns, because database might not be initialized: #{e.message}"
      return succeed!
    end

    insert_active_record_auto_validations!
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

  def insert_active_record_auto_validations!
    columns.each do |column|
      next if column.name == "id" || column.name == "created_at" || column.name == "updated_at"

      auto_validate_pesence_on_column!(column) if auto_validate_presence_on_column?(column)
      auto_validate_max_length_on_column!(column) if auto_validate_max_length_on_column?(column)
    end

    indexes.each do |index|
      auto_validate_uniqueness_on_columns!(index)
    end
  end

  def auto_validate_uniqueness_on_columns!(index)
    last_column_name = index.columns.last

    rest_of_columns = index.columns.clone
    rest_of_columns.pop

    if rest_of_columns.length.positive?
      model_class.validates last_column_name.to_sym, uniqueness: {scope: rest_of_columns}
    else
      model_class.validates last_column_name.to_sym, uniqueness: true
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
    column.type == :string && column.limit
  end

  def auto_validate_max_length_on_column!(column)
    Rails.logger.info "AutoValidate: Adding maxlength of #{column.limit} validation to #{model_class.table_name}##{column.name}"
    model_class.validates column.name.to_sym, allow_blank: true, length: {maximum: column.limit}
  end
end
