require "test_helper"

class Administrate::Task::Ui::TaskFormatterTest < ActiveSupport::TestCase
  describe "#available_tasks_hash" do
    it "returns the available tasks hash" do
      with_configuration([ "minitest", "namespaced", "error:raised", "foo:bar:baz" ]) do
        TaskRun.create(task_name: "minitest:nested:without_arguments", status: "running")

        actual_available_tasks_hash = Administrate::Task::Ui::TaskFormatter.available_tasks_hash

        assert_equal actual_available_tasks_hash.keys, [
          "error:raised",
          "minitest:nested:without_arguments",
          "minitest:with_arguments",
          "minitest:without_arguments",
          "namespaced:custom:no_comment",
          "namespaced:custom:without_arguments"
        ]
        assert_pattern do
          actual_available_tasks_hash["error:raised"] => {
            value: "error:raised",
            comment: "\"Error task\"",
            source_location: /test\/dummy\/lib\/tasks\/error\.rake/,
            arg_names: [],
            running: false
          }
        end
        assert_pattern do
          actual_available_tasks_hash["minitest:nested:without_arguments"] => {
            value: "minitest:nested:without_arguments",
            comment: "\"Nested without arguments\"",
            source_location: /test\/dummy\/lib\/tasks\/minitest\.rake/,
            arg_names: [],
            running: true
          }
        end
        assert_pattern do
          actual_available_tasks_hash["minitest:with_arguments"] => {
            value: "minitest:with_arguments",
            comment: "\"With arguments\"",
            source_location: /test\/dummy\/lib\/tasks\/minitest\.rake/,
            arg_names: [ :foo, :bar ],
            running: false
          }
        end
        assert_pattern do
          actual_available_tasks_hash["minitest:without_arguments"] => {
            value: "minitest:without_arguments",
            comment: "\"Without arguments\"",
            source_location: /test\/dummy\/lib\/tasks\/minitest\.rake/,
            arg_names: [],
            running: false
          }
        end
        assert_pattern do
          actual_available_tasks_hash["namespaced:custom:without_arguments"] => {
            value: "namespaced:custom:without_arguments",
            comment: "\"Custom task\"",
            source_location: /test\/dummy\/lib\/tasks\/namespaced\/custom\.rake/,
            arg_names: [],
            running: false
          }
        end
        assert_pattern do
          actual_available_tasks_hash["namespaced:custom:no_comment"] => {
            value: "namespaced:custom:no_comment",
            comment: "*** No description ***",
            source_location: /test\/dummy\/lib\/tasks\/namespaced\/custom\.rake/,
            arg_names: [],
            running: false
          }
        end
      end
    end
  end

  describe "#available_tasks_hash_for_field" do
    it "returns the available tasks hash for field" do
      with_configuration([ "minitest", "namespaced", "foo:bar:baz" ]) do
        TaskRun.create(task_name: "minitest:nested:without_arguments", status: "running")

        actual_available_tasks_hash_for_field = Administrate::Task::Ui::TaskFormatter.available_tasks_hash_for_field

        assert_equal actual_available_tasks_hash_for_field, [
          [ "[RUNNING] minitest:nested:without_arguments - \"Nested without arguments\"", "minitest:nested:without_arguments", { disabled: true } ],
          [ "minitest:with_arguments - \"With arguments\"", "minitest:with_arguments", { disabled: false } ],
          [ "minitest:without_arguments - \"Without arguments\"", "minitest:without_arguments", { disabled: false } ],
          [ "namespaced:custom:no_comment - *** No description ***", "namespaced:custom:no_comment", { disabled: false } ],
          [ "namespaced:custom:without_arguments - \"Custom task\"", "namespaced:custom:without_arguments", { disabled: false } ]
        ]
      end
    end
  end
end
