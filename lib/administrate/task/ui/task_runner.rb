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
          )

          # NOTE: This could be abstracted to the strategy pattern to support different processing strategies.
          task_pid = fork do
            task_run.update(
              metadata: {
                process_id: Process.pid,
                arguments: arguments
              }
            )

            rake_task = ::Rake::Task[task_name]

            rake_task.reenable

            task_run_result = with_captured_io do
              rake_task.invoke(*arguments)
            end

            task_run.update(
              status: task_run_result[:success] ? "success" : "error",
              output: task_run_result[:stdout],
              finished_at: task_run_result[:finished_at],
              metadata: {
                duration: task_run_result[:finished_at] - task_run.started_at,
                process_id: Process.pid,
                arguments: arguments,
                **Administrate::Task::Ui.metadata.call
              },
              error: build_error(task_run_result[:error])
            )
          end

          # Ensure when the child process terminates, zombie
          # processes are not left behind.
          Process.detach(task_pid)

          task_run.reload
        end

        private

        def running_task?(task_name)
          runner_class.exists?(task_name:, status: "running")
        end

        def build_error(error)
          return {} if error.blank?

          {
            class: error.class.name,
            message: error.detailed_message,
            backtrace: error.backtrace
          }
        end

        def with_captured_io
          out = StringIO.new
          old_stdout = $stdout
          $stdout = out
          success = false

          yield

          finished_at = Time.current
          success = true
          {
            stdout: out.string,
            success: success,
            finished_at: finished_at
          }
        rescue StandardError => error
          {
            stdout: out.string,
            success: false,
            finished_at: finished_at || Time.current,
            error:
          }
        ensure
          $stdout = old_stdout
        end
      end
    end
  end
end
