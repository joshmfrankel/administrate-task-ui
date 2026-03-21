module Administrate
  module Task
    module Ui
      class TaskRunner
        attr_reader :task_name, :arguments, :runner_class

        def initialize(task_name:, arguments: {})
          @task_name = task_name
          @arguments = arguments&.values || {}
          @runner_class = ::TaskRun
        end

        def call
          return :running if running_task?(task_name)
          return :not_allowed unless Administrate::Task::Ui::BuildAllowedTasks.call.map(&:to_s).include?(task_name)

          task_run = runner_class.create(
            task_name:,
            status: "running",
            output: "n/a",
            error: "n/a",
            started_at: Time.current,
            metadata: {
              arguments:
            }
          )

          Administrate::Task::Ui::TaskRunnerJob
            .perform_later(
              task_run:,
              task_name:,
              arguments:,
              metadata: Administrate::Task::Ui.metadata.call
            )

          task_run.reload
        end

        private

        def running_task?(task_name)
          runner_class.exists?(task_name:, status: "running")
        end
      end
    end
  end
end
