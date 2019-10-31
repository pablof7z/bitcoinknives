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
}
