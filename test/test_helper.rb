# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../test/dummy/db/migrate", __dir__) ]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"

require "minitest/autorun"
require "minitest/spec"
require "minitest/mock"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [ File.expand_path("fixtures", __dir__) ]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase
  include ActiveJob::TestHelper

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Enable spec-style DSL (e.g. `context` method)
  extend Minitest::Spec::DSL
  class << self
    alias context describe
  end
end

def with_configuration(allowed_tasks, metadata: -> { })
  original_allowed_tasks = Administrate::Task::Ui.allowed_tasks
  Administrate::Task::Ui.allowed_tasks = allowed_tasks

  original_metadata = Administrate::Task::Ui.metadata
  Administrate::Task::Ui.metadata = metadata
  yield
ensure
  Administrate::Task::Ui.allowed_tasks = original_allowed_tasks
  Administrate::Task::Ui.metadata = original_metadata
end
