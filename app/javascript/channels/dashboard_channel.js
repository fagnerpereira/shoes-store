import consumer from "channels/consumer"
import { createConsumer } from "@rails/actioncable"

consumer.subscriptions.create("DashboardChannel", {
  connected() {
    //console.log('dashboard', createConsumer('ws://localhost:8080'))
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    updateChartData(
      Chartkick.charts['all-sales-area-chart'],
      generateKey(new Date(data.created_at)),
      data
    )
    updateChartData(
      Chartkick.charts['sales-by-store-chart'],
      data.store_name,
      data
    )
    updateChartData(
      Chartkick.charts['sales-by-product-chart'],
      data.product_name,
      data
    )
  }
});

function updateChartData(chart, key, data) {
  console.log(chart)
  console.log(key);
  console.log(data);

  // if key is already created then increment it by 1
  let item = chart.dataSource.find(item => {
    if (item[0] === key) {
      item[1] = item[1] + 1;
      return item;
    }
  })

  // if key is not found then create a new item
  if (item != null) {
    item = [key, 1];
  }

  chart.updateData(chart.dataSource);
}

function generateKey(date, groupByTime = false) {
  // 2023-02-15T11:50:53.155Z becomes 2023-02-15T11:50:00.000Z
  date.setSeconds(0)
  date.setMilliseconds(0)

  if (groupByTime === true) {
    return date.toISOString();
  }
  return date.toISOString().split('T')[0];
}
