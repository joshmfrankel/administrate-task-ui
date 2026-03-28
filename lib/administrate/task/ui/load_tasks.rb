module Administrate
  module Task
    module Ui
      class LoadTasks
        class << self
          def call
            track_task_description_as_comment

            if should_load_tasks?
              ::Rails.application.load_tasks
              @rails_application_tasks_loaded = true
            end

            @_tasks ||= ::Rake.application.tasks
          end

          def mark_rails_tasks_loaded!
            @rails_application_tasks_loaded = true
          end

          private

          def should_load_tasks?
            return true if !::Rake.respond_to?(:application)
            return true if ::Rake.application.tasks.empty?
            return true unless @rails_application_tasks_loaded

            false
          end

          def track_task_description_as_comment
            if ::Rake::TaskManager.respond_to?(:record_task_metadata)
              Rake::TaskManager.record_task_metadata = true
            end
          end
        end
      end
    end
  end
end
