require "test_helper"

class Administrate::Task::Ui::TaskRunnerTest < ActiveSupport::TestCase
  describe "#call" do
    it "returns :running if the task is already running" do
      TaskRun.create(task_name: "minitest:nested:without_arguments", status: "running")

      result = Administrate::Task::Ui::TaskRunner.new(task_name: "minitest:nested:without_arguments").call

      assert_equal :running, result
    end

    it "returns :not_allowed if the task is not allowed" do
      result = Administrate::Task::Ui::TaskRunner.new(task_name: "say:yolo").call

      assert_equal :not_allowed, result
    end

    it "creates a new task run" do
      with_configuration([ "minitest:nested:without_arguments" ]) do
        runner = Administrate::Task::Ui::TaskRunner.new(task_name: "minitest:nested:without_arguments")
        perform_enqueued_jobs do
          result = runner.call

          assert_equal "minitest:nested:without_arguments", result.task_name
          assert_equal "success", result.status
          assert_equal "Nested without arguments\n", result.output
          assert_equal "{}", result.error
          assert_instance_of ActiveSupport::TimeWithZone, result.finished_at
          assert_equal result.metadata[:arguments], []
          assert_instance_of Float, result.metadata[:duration]
          assert_instance_of ActiveSupport::TimeWithZone, result.started_at
        end
      end
    end

    it "gracefully handles errors and metadata" do
      with_configuration([ "error:raised" ], metadata: -> { { user_id: 123 } }) do
        runner = Administrate::Task::Ui::TaskRunner.new(task_name: "error:raised")
        perform_enqueued_jobs do
          result = runner.call

          assert_equal "error:raised", result.task_name
          assert_equal "error", result.status
          assert_equal "", result.output
          formatted_error = YAML.load(result.error)
          assert_equal formatted_error["class"], "RuntimeError"
          assert_equal formatted_error["message"], "Error task (RuntimeError)"
          refute_empty formatted_error["backtrace"]

          assert_instance_of ActiveSupport::TimeWithZone, result.finished_at
          assert_equal result.metadata[:arguments], []
          assert_equal result.metadata[:user_id], 123
          assert_instance_of Float, result.metadata[:duration]
        end
      end
    end
  end
end
