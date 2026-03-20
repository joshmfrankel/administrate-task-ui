module Administrate
  module Task
    module Ui
      class BuildAllowedTasks
        class << self
          def call(loaded_tasks: ::Administrate::Task::Ui::LoadTasks.call)
            @_allowed_tasks ||= {}
            @_allowed_tasks[cache_key(loaded_tasks:)] ||= loaded_tasks.select do |task|
              Administrate::Task::Ui.allowed_tasks.any? do |allowed_task|
                task.name.start_with?(allowed_task)
              end
            end
          end

          def cache_key(loaded_tasks:)
            allowed_tasks = Administrate::Task::Ui.allowed_tasks.map(&:to_s).sort.join("\0")
            available_tasks = loaded_tasks.map(&:name).sort.join("\0")
            composite_key = [ allowed_tasks, available_tasks ].join("\u001F")

            Digest::SHA256.hexdigest(composite_key)
          end
        end
      end
    end
  end
end
