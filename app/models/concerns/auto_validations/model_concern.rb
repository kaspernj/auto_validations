module ActiveRecordAutoValidations::ModelConcern
  extend ActiveSupport::Concern

  included do |base|
    ActiveRecordAutoValidations::AutoValidateModelClass.execute!(model_class: base)
  end
end
