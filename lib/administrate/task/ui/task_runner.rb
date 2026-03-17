module Administrate
  module Task
    module Ui
      class TaskRunner
        attr_reader :task_name, :current_user

        def initialize(task_name, current_user)
          @task_name = task_name
          @current_user = current_user
        end

        def call
          task_run = ::TaskRun.create!(
            task_name:,
            status: "running",
            output: "n/a",
            error: "n/a",
            started_at: Time.current,
            user_id: current_user.id,
            metadata: {}
          )

          rake_task = ::Rake::Task[task_name]
          rake_task.reenable

          # TODO: CacheAccessor for checking for a lock on the task
          fork do
            task_run_result = with_captured_io do
              # TODO: CacheAccessor for locking the task
              rake_task.invoke
            end

            # TODO: Rename namespace to avoid collisions with Rake gem
            # TODO: Add actor_id and actor_type column
            task_run.update(
              status: task_run_result[:success] ? "success" : "error",
              output: task_run_result[:stdout],
              finished_at: task_run_result[:finished_at],
              metadata: {
                user_id: current_user.id,
                user_email: current_user.email_address,
                duration: task_run_result[:finished_at] - task_run.started_at
              },
              error: build_error(task_run_result[:error])
            )
          end

          task_run
        end

        private

        def build_error(error)
          {}.tap do |hash|
            hash[:class] = error.class.name
            hash[:message] = error.detailed_message
            hash[:backtrace] = error.backtrace
          end
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
