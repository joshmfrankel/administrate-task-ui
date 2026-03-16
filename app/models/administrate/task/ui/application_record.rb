module Administrate
  module Task
    module Ui
      class ApplicationRecord < ActiveRecord::Base
        self.abstract_class = true
      end
    end
  end
end
