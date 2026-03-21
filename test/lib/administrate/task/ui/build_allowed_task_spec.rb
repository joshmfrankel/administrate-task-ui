require "test_helper"

class Administrate::Task::Ui::BuildAllowedTasksTest < ActiveSupport::TestCase
  describe "::call" do
    context "when .allowed_tasks is not configured" do
      it "returns an empty array" do
        Administrate::Task::Ui.allowed_tasks = []

        assert_equal ::Administrate::Task::Ui::BuildAllowedTasks.call, []
      end
    end

    context "when .allowed_tasks is configured" do
      it "returns the filtered tasks for exact matches" do
        with_configuration([ "minitest:without_arguments", "namespaced:custom:without_arguments", "foo:bar:baz" ]) do
          allowed_tasks = ::Administrate::Task::Ui::BuildAllowedTasks.call

          assert_equal allowed_tasks, [
            ::Rake::Task["minitest:without_arguments"],
            ::Rake::Task["namespaced:custom:without_arguments"]
          ]
        end
      end

      it "returns the filtered tasks for partial matches" do
        with_configuration([ "minitest", "namespaced", "foo:bar:baz" ]) do
          allowed_tasks = ::Administrate::Task::Ui::BuildAllowedTasks.call

          assert_equal allowed_tasks, [
            ::Rake::Task["minitest:nested:without_arguments"],
            ::Rake::Task["minitest:with_arguments"],
            ::Rake::Task["minitest:without_arguments"],
            ::Rake::Task["namespaced:custom:no_comment"],
            ::Rake::Task["namespaced:custom:without_arguments"]
          ]
        end
      end
    end
  end
end
