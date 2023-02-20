import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {
  static targets = ['filterDays', 'filterInterval', 'theme'];

  connect() {
    if (localStorage.getItem('dark')) {
      this.themeTarget.checked = localStorage.getItem('dark') === 'true';
      this.switchTheme();
    } else {
      this.themeTarget.checked = false;
      this.switchTheme();
    }
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

  switchTheme() {
    const htmlTag = document.querySelector('html');

    if (this.themeTarget.checked) {
      htmlTag.dataset.theme = 'dark';
      localStorage.setItem('dark', true);
    } else {
      htmlTag.dataset.theme = 'light';
      localStorage.setItem('dark', false);
    }
  }
}
