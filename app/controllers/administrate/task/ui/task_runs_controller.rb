module Administrate
  module Task
    module Ui
      class TaskRunsController < ::Admin::ApplicationController
        def create
          result = ::Administrate::Task::Ui::TaskRunner.new(
            task_name: task_run_params[:task_name],
            current_user:,
            arguments: task_run_params[:arguments]
          ).call

          redirect_to admin_task_run_path(result), notice: "Task #{task_run_params[:task_name]} is running..."
        end

        def new
          @tasks = ::Administrate::Task::Ui::TaskFormatter.available_tasks_hash

          super
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
          ::TaskRun.order(finished_at: :desc)
        end

        # def resource_class
        #   ::Administrate::Task::Ui::TaskRun
        # end
      end
    end
  end
end
