import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = []

  show_modal(e) {
    document.querySelector('[data-modal="upgrade-modal"]').click()
    e.target.blur()
    e.preventDefault()
  }
}
