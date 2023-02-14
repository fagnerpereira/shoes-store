import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sales"
export default class extends Controller {
  connect() {
    let salesTable = document.getElementById('sales');

    document.addEventListener('turbo:before-stream-render', (event) => {
      if (event.detail.newStream.attributes.action.value === 'prepend') {
        let rowsCount = salesTable.rows.length;

        if (rowsCount > 50) {
          salesTable.deleteRow(rowsCount - 1);
        }
        //console.log(document.getElementById('sales').rows.length);
      }
      //console.log(event.detail.newStream.attributes)
      //console.log(event.detail.newStream.attributes.action.value === 'prepend')
    })
  }
}
