module Administrate
  module Task
    module Ui
      class TaskFormatter
        attr_reader :available_tasks

        def initialize(available_tasks = [])
          @available_tasks = available_tasks.presence || ::Administrate::Task::Ui::TaskLoader.available_tasks
        end

        class << self
          def available_tasks_hash
            new.available_tasks_hash
          end

          def available_tasks_hash_for_field
            new.available_tasks_hash_for_field
          end
        end

        def available_tasks_hash
          @_available_tasks_hash ||= {}.tap do |hash|
            available_tasks.each do |task|
              hash[task.name] = {
                value: task.name,
                comment: task.full_comment || "*** No description ***",
                source_location: task.actions[0].source_location[0],
                arg_names: task.arg_names
              }
            end
          end
        end

        def available_tasks_hash_for_field
          @_available_tasks_hash_for_field ||= available_tasks_hash.map do |key, value|
            display = key
            display += " - #{value[:comment]}"
            [ display, key ]
          end
        end
      end
    end
  end
end
