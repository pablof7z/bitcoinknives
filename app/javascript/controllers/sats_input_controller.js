import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = [
    "input",
    "converted"
  ]

  connect() {
    alert('hi');
  }
}
