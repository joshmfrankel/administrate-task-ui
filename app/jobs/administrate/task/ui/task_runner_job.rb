module Administrate::Task::Ui
  class TaskRunnerJob < ApplicationJob
    queue_as :default

    def perform(task_run:, task_name:, arguments:, metadata:)
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
          arguments:,
          **metadata
        },
        error: build_error(task_run_result[:error])
      )
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
