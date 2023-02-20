import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {
  static targets = ['filterDays', 'filterInterval'];

  connect() {
    this.disabledFilterIntervalOption();
  }

  disabledFilterIntervalOption() {
    const monthlyOption = this.filterIntervalTarget.options[this.filterIntervalTarget.length - 1];

    if (this.filterDaysTarget.value === '7') {
      monthlyOption.disabled = true;
    } else {
      monthlyOption.disabled = false;
    }
  }

  switchTheme(e) {
    const htmlTag = document.querySelector('html');

    if (e.target.checked) {
      htmlTag.dataset.theme = 'dark';
    } else {
      htmlTag.dataset.theme = 'light';
    }
  }
}
