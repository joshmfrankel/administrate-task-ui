module Administrate
  module Task
    module Ui
      class TaskFormatter
        attr_reader :available_tasks

        def initialize(available_tasks = [])
          @available_tasks = available_tasks.presence || ::Administrate::Task::Ui::BuildAllowedTasks.call
        end

        class << self
          def available_tasks_hash
            new.available_tasks_hash
          end

          def available_tasks_hash_for_field
            new.available_tasks_hash_for_field
          end
        end

        def task_running?(task_name)
          running_tasks.include?(task_name)
        end

        def running_tasks
          @_running_tasks ||= ::TaskRun.where(status: "running").pluck(:task_name)
        end

        def available_tasks_hash
          @_available_tasks_hash ||= {}.tap do |hash|
            available_tasks.each do |task|
              comment = task.full_comment.present? ? "\"#{task.full_comment}\"" : "*** No description ***"
              hash[task.name] = {
                value: task.name,
                comment:,
                source_location: task.actions[0].source_location[0],
                arg_names: task.arg_names,
                running: task_running?(task.name)
              }
            end
          end
        end

        def available_tasks_hash_for_field
          @_available_tasks_hash_for_field ||= available_tasks_hash.map do |key, value|
            display = key
            task_running = task_running?(key)
            display += " - #{value[:comment]}"
            display = "[RUNNING] #{display}" if task_running
            [ display, key, disabled: task_running ]
          end
        end
      end
    end
  end
end
