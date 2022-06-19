module AutoValidations::ModelConcern
  extend ActiveSupport::Concern

  included do |base|
    AutoValidations::AutoValidateModelClass.execute!(model_class: base)
  end
end
