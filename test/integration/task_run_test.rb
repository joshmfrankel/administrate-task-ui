require "test_helper"

class TaskRunTest < ActionDispatch::IntegrationTest
  describe "GET#index" do
    it "renders the index page" do
      TaskRun.create(task_name: "minitest:nested:without_arguments", status: "success")

      get admin_task_runs_path

      assert_includes response.body, "minitest:nested:without_arguments"
      assert_response :success
    end
  end

  describe "GET#new" do
    it "renders the new page" do
      get new_admin_task_run_path

      assert_response :success
    end
  end

  describe "POST#create" do
    context "when the task is not allowed" do
      it "redirects to the task runs page with an error" do
        post admin_task_runs_path, params: { task_run: { task_name: "minitest:nested:without_arguments" } }

        assert_redirected_to admin_task_runs_path
        assert_equal flash[:error], "Task minitest:nested:without_arguments is not allowed."
      end
    end

    context "when the task is running" do
      it "redirects to the task runs page with an error" do
        with_configuration([ "minitest:nested:without_arguments" ]) do
          TaskRun.create(task_name: "minitest:nested:without_arguments", status: "running")
          post admin_task_runs_path, params: { task_run: { task_name: "minitest:nested:without_arguments" } }

          assert_equal flash[:alert], "Task minitest:nested:without_arguments is already running."
          assert_redirected_to admin_task_runs_path
        end
      end
    end

    context "when the task is created" do
      it "redirects to the task run page with a success message" do
        with_configuration([ "minitest:nested:without_arguments" ]) do
          post admin_task_runs_path, params: { task_run: { task_name: "minitest:nested:without_arguments" } }

          assert_equal flash[:notice], "Task minitest:nested:without_arguments is running..."
          assert_redirected_to admin_task_run_path(TaskRun.last)
        end
      end
    end
  end

  describe "GET#source_code" do
    it "redirects to the new task run page if the task name is not found" do
      get source_code_admin_task_runs_path(task_name: "minitest:nested:without_arguments")

      assert_redirected_to new_admin_task_run_path
    end

    context "when the task name is found" do
      it "renders the source code" do
        with_configuration([ "minitest:nested:without_arguments" ]) do
          get source_code_admin_task_runs_path(task_name: "minitest:nested:without_arguments")

          assert_equal response.body, File.read("./test/dummy/lib/tasks/minitest.rake")
          assert_response :success
        end
      end
    end
  end
end
