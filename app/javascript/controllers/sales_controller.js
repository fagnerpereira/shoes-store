import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="sales"
export default class extends Controller {
  connect() {
    console.log(Turbo)


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

  handleStreamUpdate(data) {
    console.log(data)
    // get the Turbo Streams updates from the data
    const streamUpdates = Turbo.parseStreamMessage(data)

    // loop through the updates and apply them to the page
    //streamUpdates.forEach(update => {
    //  const targetId = update.target
    //  const target = this.listTarget.querySelector(`[data-id="${targetId}"]`)
    //  if (target) {
    //    Turbo.renderStreamUpdate(target, update)
    //  } else {
    //    Turbo.renderStreamElement(update)
    //  }
    //})
  }
}
