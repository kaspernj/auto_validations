class ActiveRecordAutoValidations::AutoUniqueIndex
  def self.execute!(**args)
    ActiveRecordAutoValidations::AutoUniqueIndex.new(**args).perform
  end

  attr_reader :columns, :index, :model_class

  def initialize(columns:, index:, model_class:)
    @columns = columns
    @index = index
    @model_class = model_class
  end

  def perform
    model_class.validates last_column_name.to_sym, **validates_args
  end

  def index_columns
    @index_columns ||= index.columns.map { |column_name| columns.find { |column| column.name == column_name } }
  end

  def last_column_name
    @last_column_name ||= index.columns.last
  end

  def validates_args
    rest_of_columns = index.columns.clone
    rest_of_columns.pop

    validates_args = {}

    if rest_of_columns.length.positive?
      validates_args[:uniqueness] ||= {}
      validates_args[:uniqueness][:scope] = rest_of_columns
    end

    validates_args[:allow_blank] = true if index_columns.any?(&:null)
    validates_args[:uniqueness] ||= true
    validates_args
  end
end
