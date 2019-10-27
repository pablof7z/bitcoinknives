import consumer from "./consumer"

consumer.subscriptions.create("TradesChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    self.location.href = '/rules/' + data.rule_id + '/trades/' + data.trade_id
  }
});
