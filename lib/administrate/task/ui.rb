require "rake"
require "administrate/task/ui/version"
require "administrate/task/ui/engine"
require "administrate/task/ui/task_loader"
require "administrate/task/ui/task_runner"
require "administrate/task/ui/task_formatter"

module Administrate
  module Task
    module Ui
      mattr_accessor :allowed_tasks, default: []
    end
  end
end
