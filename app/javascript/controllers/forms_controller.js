import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms"
export default class extends Controller {
  static targets = ['field']

  connect() {
    this.valid = true;
  }

  beforeSubmit(e) {
    this.valid = true;
    e.preventDefault();

    this.fieldTargets.forEach(field => {
      this.validates(field);
    })

    if (this.valid) {
      e.detail.resume();
    }
  }

  validatesField(event) {
    this.validates(event.target);
  }

  validates(field) {
    if (field.value === '') {
      field.setAttribute('aria-invalid', 'true');
      this.valid = false;
    } else {
      field.setAttribute('aria-invalid', 'false');
    }
  }
}
