Rails.autoloaders.main.on_load do |_klass_name, klass, _defined_by_file|
  ActiveRecordAutoValidations::OnLoad.execute!(klass: klass)
end
