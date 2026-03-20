require "rails/generators/base"
require "rails/generators/migration"
require "rails/generators/active_record"
require "administrate/generator_helpers"

module Administrate
  module Task
    module Ui
      class InstallGenerator < Rails::Generators::Base
        include ::Rails::Generators::Migration
        include ::Administrate::GeneratorHelpers

        source_root File.expand_path("../templates", __FILE__)

        def generate_migration
          migration_template(
            "db/migrate/create_admin_task_runs.rb.erb",
            "db/migrate/create_admin_task_runs.rb"
          )
        end

        def generate_initializer
          template(
            "config/initializers/administrate_task_ui.rb.erb",
            "config/initializers/administrate_task_ui.rb"
          )
        end

        # @see https://github.com/rails/rails/blob/ffcbf6f205363f8c2fb3e9834bc86690dd59f1cb/railties/lib/rails/generators/actions.rb#L489
        def inject_routes
          routes = <<~ROUTES
            resources :task_runs, only: [ :new, :create, :index, :show ] do
              get "source_code", on: :collection
            end
          ROUTES

          inject_into_file("config/routes.rb", after: "namespace :admin do\n") do
            routes.strip_heredoc.indent(4)
          end
        end

        def self.next_migration_number(dir)
          ::ActiveRecord::Generators::Base.next_migration_number(dir)
        end

        private

        def migration_version
          "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
        end
      end
    end
  end
end
