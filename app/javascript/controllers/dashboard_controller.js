import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {
  static targets = ['theme'];

  connect() {
    if (localStorage.getItem('dark')) {
      this.themeTarget.checked = localStorage.getItem('dark') === 'true';
      this.switchTheme();
    } else {
      this.themeTarget.checked = false;
      this.switchTheme();
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
