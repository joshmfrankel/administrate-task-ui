module Administrate
  module Task
    module Ui
      class TaskLoader
        class << self
          def available_tasks
            load_tasks

            @_available_tasks ||= ::Rake.application.tasks.select do |task|
              Administrate::Task::Ui.allowed_tasks.any? do |allowed_task|
                task.name.start_with?(allowed_task)
              end
            end
          end

          private

          def load_tasks
            should_load_tasks = false

            if !::Rake.respond_to?(:application)
              should_load_tasks = true
            end

            if should_load_tasks == false && ::Rake.respond_to?(:application) && ::Rake.application.tasks.empty?
              should_load_tasks = true
            end

            track_task_description_as_comment

            if should_load_tasks
              ::Rails.application.load_tasks
            end
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
