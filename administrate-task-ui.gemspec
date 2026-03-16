require_relative "lib/administrate/task/ui/version"

Gem::Specification.new do |spec|
  spec.name        = "administrate-task-ui"
  spec.version     = Administrate::Task::Ui::VERSION
  spec.authors     = [ "Josh Frankel" ]
  spec.email       = [ "joshmfrankel@gmail.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of Administrate::Task::Ui."
  spec.description = "TODO: Description of Administrate::Task::Ui."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.2"
  spec.add_dependency "administrate", ">= 0.19.0"
  spec.add_dependency "rake", ">= 13.0.0"
end
