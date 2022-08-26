Rails.autoloaders.main.on_load do |klass_name, klass, defined_by_file|
  ActiveRecordAutoValidations::OnLoad.execute!(klass: klass)
end
