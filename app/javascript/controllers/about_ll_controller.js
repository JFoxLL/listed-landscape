import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["question", "answer"];

  toggle(event) {
    const question = event.currentTarget;
    const answer = question.nextElementSibling;

    if (answer.style.display === "block") {
      answer.style.display = "none";
      question.querySelector(".about-ll-toggle-icon").textContent = "+";
    } else {
      answer.style.display = "block";
      question.querySelector(".about-ll-toggle-icon").textContent = "-";
    }
  }
}
