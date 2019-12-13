import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = [
    "exchange",
    "instructions"
  ]

  show_info() {
    let sel = this.exchangeTarget.value.toLowerCase()
    sel = sel.replace(' ', '_');

    (document.querySelectorAll('.instructions > *') || []).forEach(($el) => {
      if ($el.id != sel) { $el.classList.add('hidden') };
    })

    document.getElementById(sel).classList.remove('hidden')
  }

  display_correct_fields() {
    let exchange = this.exchangeTarget.value.toLowerCase();
    exchange = exchange.replace(' ', '_');

    (document.querySelectorAll('#fields, #instructions > *') || []).forEach(($el) => {
      if (!$el.classList.contains(exchange)) { $el.classList.add('hidden') };
    });

    if (exchange != '') {
      (document.querySelectorAll('#fields.'+exchange+', #instructions > .'+exchange) || []).forEach(($el) => {
        if ($el.classList.contains(exchange)) { $el.classList.remove('hidden') };
      });
    }
  }

  connect() {
    this.display_correct_fields()
  }
}
