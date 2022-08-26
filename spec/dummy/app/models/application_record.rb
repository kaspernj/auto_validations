class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.inherited(child)
    super
    child.include ActiveRecordAutoValidations::ModelConcern
  end
end
