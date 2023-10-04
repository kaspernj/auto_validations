Rails.autoloaders.main.on_load do |class_name, klass, _defined_by_file|
  if class_name == "Task"
    ActiveRecordAutoValidations::AutoValidateModelClass.execute!(
      ignore_column_names: ["name"],
      model_class: klass
    )
  else
    ActiveRecordAutoValidations::OnLoad.execute!(klass: klass)
  end
end
