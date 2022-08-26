require_relative "lib/active_record_auto_validations/version"

Gem::Specification.new do |spec|
  spec.name        = "active_record_auto_validations"
  spec.version     = ActiveRecordAutoValidations::VERSION
  spec.authors     = ["kaspernj"]
  spec.email       = ["k@spernj.org"]
  spec.homepage    = "https://github.com/kaspernj/active_record_auto_validations"
  spec.summary     = "Scans ActiveRecord models and adds automatic validations based on null, max length etc."
  spec.description = "Scans ActiveRecord models and adds automatic validations based on null, max length etc."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kaspernj/active_record_auto_validations"
  spec.metadata["changelog_uri"] = "https://github.com/kaspernj/active_record_auto_validations"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.3"
  spec.add_runtime_dependency "service_pattern", ">= 1.0.8"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rails"
  spec.add_development_dependency "rubocop-rspec"
  spec.metadata["rubygems_mfa_required"] = "true"
end
