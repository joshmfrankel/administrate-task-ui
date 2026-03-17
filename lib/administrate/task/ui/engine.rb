module Administrate
  module Task
    module Ui
      class Engine < ::Rails::Engine
        isolate_namespace Administrate::Task::Ui

        initializer "administrate.task.ui.assets" do
          Administrate::Engine.add_javascript "administrate/task/ui/application"
          Administrate::Engine.add_stylesheet "administrate/task/ui/application"
        end
      end
    end
  end
end
