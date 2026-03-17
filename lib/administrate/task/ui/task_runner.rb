module Administrate
  module Task
    module Ui
      class TaskRunner
        attr_reader :task_name, :current_user, :arguments

        def initialize(task_name:, current_user:, arguments: {})
          @task_name = task_name
          @current_user = current_user
          @arguments = arguments&.values || {}
        end

        def call
          # TODO: CacheAccessor should early return if there is a lock here
          # TODO: CacheAccessor should lock here
          task_run = ::TaskRun.create(
            task_name:,
            status: "running",
            output: "n/a",
            error: "n/a",
            started_at: Time.current,
            user_id: current_user.id,
          )
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
                user_id: current_user.id,
                user_email: current_user.email_address,
                duration: task_run_result[:finished_at] - task_run.started_at,
                process_id: Process.pid,
                arguments: arguments
              },
              error: build_error(task_run_result[:error])
            )

            # TODO: CacheAccessor should unlock here
          end

          # Ensure when the child process terminates, zombie
          # processes are not left behind.
          Process.detach(task_pid)

          task_run.reload
        end

        private

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
