module Administrate
  module Task
    module Ui
      class TaskLoader
        def self.load_tasks
          should_load_tasks = false

          if !::Rake.respond_to?(:application)
            should_load_tasks = true
          end

          if ::Rake.respond_to?(:application) && ::Rake.application.tasks.empty?
            should_load_tasks = true
          end

          if ::Rake::TaskManager.respond_to?(:record_task_metadata)
            Rake::TaskManager.record_task_metadata = true
          end

          if should_load_tasks
            ::Rails.application.load_tasks
          end
        end

        def self.available_tasks
          load_tasks

          allowed_tasks = [
            "next:hello",
            "say",
            "argument"
          ]

          @available_tasks ||= ::Rake.application.tasks.select do |task|
            allowed_tasks.any? do |allowed_task|
              task.name.start_with?(allowed_task)
            end
          end
        end

        def self.available_tasks_hash
          @available_tasks_hash ||= {}.tap do |hash|
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

        def self.available_tasks_hash_for_field
          available_tasks_hash.map do |key, value|
            display = key
            display += " - #{value[:comment]}"
            [ display, key ]
          end
        end
      end
    end
  end
end
