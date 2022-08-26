class ActiveRecordAutoValidations::OnLoad
  def self.execute!(klass:)
    # This callback is going to be called for all classes. We should only run auto-validations on the ones that have had the module included
    # which is done through the marked-variable.
    marked = klass.instance_variable_get(:@active_record_auto_validations_marked)

    ActiveRecordAutoValidations::AutoValidateModelClass.execute!(model_class: klass) if marked
  end
end
