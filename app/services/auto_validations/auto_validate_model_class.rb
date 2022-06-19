class AutoValidations::AutoValidateModelClass < ApplicationService
  attr_reader :model_class

  def initialize(model_class:)
    @model_class = model_class
  end

  def perform
    begin
      columns
    rescue ActiveRecord::StatementInvalid => e
      # Database is probably not running - we need to ignore this to make stuff like db:migrate, db:schema:load work
      Rails.logger.error "AutoValidate: Ignoring error while loading columns, because database might not be initialized: #{e.message}"
      return succeed!
    end

    insert_auto_validations!
    succeed!
  end

  def columns
    @columns ||= model_class.columns
  end

  def insert_auto_validations!
    columns.each do |column|
      next if column.name == "id" || column.name == "created_at" || column.name == "updated_at"

      auto_validate_pesence_on_column!(column) if auto_validate_presence_on_column?(column)
      auto_validate_max_length_on_column!(column) if auto_validate_max_length_on_column?(column)
    end
  end

  def auto_validate_presence_on_column?(column)
    !column.null && !column.name.end_with?("_id") && column.default.nil?
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
