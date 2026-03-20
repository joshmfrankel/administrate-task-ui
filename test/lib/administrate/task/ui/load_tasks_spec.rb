require "test_helper"

class Administrate::Task::Ui::LoadTasksTest < ActiveSupport::TestCase
  describe "::call" do
    context "when the Rake application is not loaded" do
      it "loads the tasks" do
        rake_mock = Minitest::Mock.new
        rake_mock.expect(:call, false, [ :application ])

        ::Rake.stub(:respond_to?, rake_mock) do
          refute_empty ::Administrate::Task::Ui::LoadTasks.call
        end
      end
    end

    context "when the Rake application is loaded" do
      context "when the Rake application has no tasks" do
        it "loads the tasks" do
          rake_mock = Minitest::Mock.new
          rake_mock.expect(:call, true, [ :application ])

          ::Rake.stub(:respond_to?, rake_mock) do
            refute_empty ::Administrate::Task::Ui::LoadTasks.call
          end
        end
      end

      context "when the Rake application has tasks loaded" do
        it "returns the tasks but does not load them" do
          ::Rails.application.load_tasks

          rails_app = Object.new
          rails_app.define_singleton_method(:load_tasks) do
            fail("expected Rails.application.load_tasks not to be called")
          end

          refute_empty Rake.application.tasks
          ::Rails.stub(:application, rails_app) do
            refute_empty ::Administrate::Task::Ui::LoadTasks.call
          end
        end
      end
    end
  end
end
