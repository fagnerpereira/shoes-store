import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sales"
export default class extends Controller {
  connect() {
    let salesTable = document.getElementById('sales');
    let limit = 50;

    document.addEventListener('turbo:before-stream-render', (event) => {
      if (event.detail.newStream.attributes.action.value === 'prepend') {
        let rowsCount = salesTable.rows.length;

        if (rowsCount > limit) {
          let rowsToDelete = rowsCount - limit;
          let lastRow = rowsCount - 1;

          for (let i = 0; i < rowsToDelete; i++) {
            salesTable.deleteRow(lastRow--);
          }
        }
        //console.log(document.getElementById('sales').rows.length);
      }
      //console.log(event.detail.newStream.attributes)
      //console.log(event.detail.newStream.attributes.action.value === 'prepend')
    })
  }
}
