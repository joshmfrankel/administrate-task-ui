module Administrate
  module Task
    module Ui
      class TaskRunsController < ::Admin::ApplicationController
        def new
          @tasks = ::Administrate::Task::Ui::TaskFormatter.available_tasks_hash

          super
        end

        def create
          result = ::Administrate::Task::Ui::TaskRunner.new(
            task_name: task_run_params[:task_name],
            arguments: task_run_params[:arguments]
          ).call

          case result
          when :running
            redirect_to admin_task_runs_path, alert: "Task #{task_run_params[:task_name]} is already running."
          when :not_allowed
            flash[:error] = "Task #{task_run_params[:task_name]} is not allowed."
            redirect_to admin_task_runs_path
          else
            redirect_to admin_task_run_path(result), notice: "Task #{task_run_params[:task_name]} is running..."
          end
        end

        def source_code
          # TODO: guard against missing file
          @source_code ||= File.read(
            ::Administrate::Task::Ui::TaskFormatter.available_tasks_hash[params[:task_name]][:source_location]
          )

          render plain: @source_code
        end

        private

        def task_run_params
          params.require(:task_run).permit(:task_name, arguments: {})
        end

        def scoped_resource
          resource_class.order(finished_at: :desc)
        end
      end
    end
  end
end
