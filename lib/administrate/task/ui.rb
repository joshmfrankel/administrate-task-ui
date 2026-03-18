require "rake"
require "administrate/task/ui/version"
require "administrate/task/ui/engine"
require "administrate/task/ui/task_loader"
require "administrate/task/ui/task_runner"
require "administrate/task/ui/task_formatter"

module Administrate
  module Task
    module Ui
      # The Rake Tasks that are allowed to be discovered. This is permissive
      # in that it will discover tasks that start with the supplied values.
      #
      # Example:
      # Administrate::Task::Ui.allowed_tasks = [
      #   "next:hello",
      #   "say",
      #   "argument"
      # ]
      #
      # This will discover the following tasks:
      # - next:hello
      # - next:hello:world
      # - say
      # - argument
      # - argument:value
      # - argument:value:another_value
      #
      # @return [Array<String>]
      mattr_accessor :allowed_tasks, default: []

      # A Proc that returns additional user metadata to be stored on the TaskRun.
      # @return [Proc]
      mattr_accessor :metadata, default: -> { }
    end
  end
end
