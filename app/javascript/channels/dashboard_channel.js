import consumer from "channels/consumer"

consumer.subscriptions.create("DashboardChannel", {
  connected() {
    console.log('dashboard channel connected')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('received', data)
  }
});
