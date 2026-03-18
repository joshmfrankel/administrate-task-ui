module Administrate
  module Task
    module Ui
      class TaskRun < ApplicationRecord
        self.table_name = "admin_task_runs"

        serialize :metadata, coder: YAML
      end
    end
  end
end
