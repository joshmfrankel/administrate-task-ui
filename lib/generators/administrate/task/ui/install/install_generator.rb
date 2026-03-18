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

        # TODO: Setup base classes, inject empty override files for each

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

        # def generate_model
        #   template(
        #     "models/administrate/task/ui/task_run.rb.erb",
        #     "app/models/administrate/task/ui/task_run.rb"
        #   )
        # end

        # def generate_controller
        #   template(
        #     "controllers/admin/task_runs_controller.rb.erb",
        #     "app/controllers/admin/task_runs_controller.rb"
        #   )
        # end

        # def generate_dashboard
        #   template(
        #     "dashboards/admin/task_run_dashboard.rb.erb",
        #     "app/dashboards/admin/task_run_dashboard.rb"
        #   )
        # end

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
