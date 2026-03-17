import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sourceCode"];
  static values = {
    url: String,
    currentTaskName: { type: String, default: "" },
    loaded: { type: Boolean, default: false },
  };

  async loadSourceCode() {
    this.#setCurrentTaskName();

    if (this.loadedValue) {
      return;
    }

    this.sourceCodeTarget.innerHTML = `${this.currentTaskNameValue}: loading...`;

    const response = await fetch(
      `${this.urlValue}?task_name=${this.currentTaskNameValue}`,
    );
    const text = await response.text();

    this.sourceCodeTarget.innerHTML = text;
    this.loadedValue = true;
  }

  #setCurrentTaskName() {
    const selectField = document.querySelector(
      'form select[name="task_run[task_name]"]',
    );

    // Ensure we only load the source code if the task has changed
    if (this.currentTaskNameValue === selectField.value) {
      this.loadedValue = true;
    } else {
      this.loadedValue = false;
    }

    this.currentTaskNameValue = selectField.value;
  }
}
