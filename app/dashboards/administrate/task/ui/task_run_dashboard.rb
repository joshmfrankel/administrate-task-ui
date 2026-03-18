require "administrate/base_dashboard"

module Administrate
  module Task
    module Ui
      class TaskRunDashboard < ::Administrate::BaseDashboard
        ATTRIBUTE_TYPES = {
          id: Field::Number,
          task_name: Field::Select.with_options(
            collection: -> {
              ::Administrate::Task::Ui::TaskFormatter.available_tasks_hash_for_field
            }
          ),
          status: Field::String,
          output: Field::Text,
          error: Field::Text,
          metadata: Field::Text,
          started_at: Field::DateTime,
          finished_at: Field::DateTime,
          duration: Field::String.with_options(
            getter: ->(field) do
              if field.resource.finished_at && field.resource.started_at
                field.resource.finished_at - field.resource.started_at
              else
                "n/a"
              end
            end
          )
        }

        COLLECTION_ATTRIBUTES = %i[
          id
          task_name
          status
          started_at
          finished_at
          duration
        ]

        SHOW_PAGE_ATTRIBUTES = %i[
          id
          task_name
          status
          output
          error
          metadata
          started_at
          finished_at
        ]

        FORM_ATTRIBUTES = %i[
          task_name
        ]

        COLLECTION_FILTERS = {
          status: ->(resources, value) { resources.where(status: value) }
        }
      end
    end
  end
end
