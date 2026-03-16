module Administrate
  module Task
    module Ui
      class Engine < ::Rails::Engine
        isolate_namespace Administrate::Task::Ui
      end
    end
  end
end
