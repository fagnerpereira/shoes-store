import consumer from "channels/consumer"

consumer.subscriptions.create("DashboardChannel", {
  connected() {
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    updateChartData(
      Chartkick.charts['all-sales-area-chart'],
      generateKey(new Date(data.created_at))
    )
    updateChartData(
      Chartkick.charts['sales-by-store-chart'],
      data.store_name
    )
    updateChartData(
      Chartkick.charts['sales-by-product-chart'],
      data.product_name
    )
  }
});

function updateChartData(chart, key) {
  let item = chart.dataSource.find(item => {
    if (item[0] === key) {
      item[1] = item[1] + 1;
      return item;
    }
  })

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

//function generateKey(date, groupByTime = false) {
//  // 2023-02-15T11:50:53.155Z becomes 2023-02-15T11:50:00.000Z
//  date.setSeconds(0);
//  date.setMilliseconds(0);
//
//  if (groupByTime === true) {
//    return date.toISOString();
//  }
//
//  date.setHours(0);
//  date.setMinutes(0);
//  return date.toString();
//}
