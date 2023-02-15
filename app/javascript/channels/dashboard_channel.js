import consumer from "channels/consumer"

consumer.subscriptions.create("DashboardChannel", {
  connected() {
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },


  received(data) {
    // this is to test different groups (group_by_day, group_by_minute, group_by_hour)
    let groupByTime = false;

    const salesChart = Chartkick.charts['all-sales-area-chart']
    const currentChartData = salesChart.dataSource;
    const dateTime = new Date(data.created_at)

    // 2023-02-15T11:50:53.155Z becomes 2023-02-15T11:50:00.000Z
    dateTime.setSeconds(0)
    dateTime.setMilliseconds(0)

    let itemKey;
    if (groupByTime === true) {
      itemKey = dateTime.toISOString()
    } else {
      itemKey = dateTime.toISOString().split('T')[0]
    }
    let item = currentChartData.find(item => item[0] === itemKey);

    if (item == null) {
      item = [itemKey, 1]
    } else {
      item[1] = item[1] + 1;
    }

    salesChart.updateData(currentChartData)
  }
});
