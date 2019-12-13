import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = [
    "input",
    "value"
  ]

  connect() {
    this.update();
  }

  update() {
    let val = this.inputTarget.value;
    let multiplier;

    if (val.search(/billion/i) > 0) {
      multiplier = 1000000000;
    } else if (val.search(/million/i) > 0) {
      multiplier = 1000000;
    } else if (val.search(/(thousand|k$)/i) > 0) {
      multiplier = 1000;
    } else {
      multiplier = 1;
    }

    val = parseFloat(val) * multiplier;
    val = val / 100000000;

    if (isNaN(val)) {
      val = "";
    } else {
      val = `${val} btc`
    }

    this.valueTarget.innerHTML = val;
  }
}
