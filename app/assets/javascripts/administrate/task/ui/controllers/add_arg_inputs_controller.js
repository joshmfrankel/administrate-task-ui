import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["inputContainer"];
  static values = {
    availableTasks: Object,
    currentArgNames: { type: Array, default: [] },
  };

  // @see https://selectize.dev/docs/events
  connect() {
    const selectField = this.element.querySelector(
      'select[name="task_run[task_name]"]',
    );

    this.handleTaskNameChange(selectField.value);

    selectField.selectize.on("change", (optionValue) =>
      this.handleTaskNameChange(optionValue),
    );
  }

  handleTaskNameChange(optionValue) {
    this.#setCurrentArgNames(optionValue);

    const argInputs = this.currentArgNamesValue.map((argName) => {
      return `
        <div class="field-unit field-unit--string field-unit--optional">
          <div class="field-unit__label">
            <label for="task_run[arguments][${argName}]">${argName} (arg)</label>
          </div>
          <div class="field-unit__field">
            <input type="text" name="task_run[arguments][${argName}]" id="task_run_arguments_${argName}">
          </div>
        </div>
      `;
    });
    this.inputContainerTarget.innerHTML = argInputs.join("");
  }

  #setCurrentArgNames(taskName) {
    this.currentArgNamesValue =
      this.availableTasksValue[taskName]?.arg_names || [];
  }
}
