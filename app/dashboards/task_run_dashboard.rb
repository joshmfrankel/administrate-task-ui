require "administrate/base_dashboard"

class TaskRunDashboard < ::Administrate::Task::Ui::TaskRunDashboard
  # @example
  # Example of how to add custom attributes from TaskRun metadata to your dashboard
  #
  # ATTRIBUTE_TYPES.merge!(
  #   user_id: Field::String.with_options(
  #     getter: ->(field) do
  #       field.resource.metadata["user_id"]
  #     end
  #   )
  # )
  #
  # COLLECTION_ATTRIBUTES.push(:user_id)
  #
  # COLLECTION_FILTERS.merge!(
  #   user_id: ->(resources, value) do
  #     resources.where("metadata LIKE ?", "%user_id: #{value}%")
  #   end
  # )
end
