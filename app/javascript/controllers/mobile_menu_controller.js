import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.element.classList.toggle('menu-active');
    this.menuTarget.classList.toggle('menu-active');
  }
}
