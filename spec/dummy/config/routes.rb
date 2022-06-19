Rails.application.routes.draw do
  mount ActiveRecordAutoValidations::Engine => "/active_record_auto_validations"
end
