module ActiveRecordAutoValidations::ModelConcern
  extend ActiveSupport::Concern

  included do |base|
    # The actual loading needs to be done after the model has been fully loaded,
    # so this is actually done through a "on_load"-callback in an initializer.
    #
    # Kind of a hack but haven't been able to find another way of doing this
    base.instance_variable_set(:@active_record_auto_validations_marked, true)
  end
end
