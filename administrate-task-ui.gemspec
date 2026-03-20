require_relative "lib/administrate/task/ui/version"

Gem::Specification.new do |spec|
  spec.name        = "administrate-task-ui"
  spec.version     = Administrate::Task::Ui::VERSION
  spec.authors     = [ "Josh Frankel" ]
  spec.email       = [ "joshmfrankel@gmail.com" ]
  spec.homepage    = "https://github.com/joshmfrankel/administrate-task-ui"
  spec.summary     = "Run any Rake tasks directly inside Administrate."
  spec.license     = "ANTIRACIST ETHICAL SOURCE LICENSE (ATR)"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.2"
  spec.add_dependency "administrate", ">= 0.19.0"
  spec.add_dependency "rake", ">= 13.0.0"

  spec.add_development_dependency "minitest-mock"
end
