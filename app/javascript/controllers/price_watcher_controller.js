import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = [
    "price"
  ]

  connect() {
    let priceWatcherController = this;

    consumer.subscriptions.create({
      channel: "PriceChannel",
      period: this.data.get('period'),
    }, {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        priceWatcherController.priceTarget.textContent = parseFloat(data.change_percentage).toFixed(2) + '%'
        if (parseFloat(data.change_percentage) > 0) {
          priceWatcherController.priceTarget.parentElement.className = 'price-up'
        } else if (parseFloat(data.change_percentage) < 0) {
          priceWatcherController.priceTarget.parentElement.className = 'price-down'
        } else {
          priceWatcherController.priceTarget.parentElement.className
        }
      }
    });
  }
}
