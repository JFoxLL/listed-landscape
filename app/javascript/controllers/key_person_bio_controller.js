import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["bio", "toggleButton"];

  // This method runs when the controller is connected to the DOM
  connect() {
    this.cleanBrTags();
  }
  
  // New function to clean up the <br> tags
  cleanBrTags() {
    this.bioTargets.forEach((bio) => {
      bio.innerHTML = bio.innerHTML.replace(/&lt;br&gt;/g, '<br>').replace(/<br>/g, '<br>');
    });
  }
  
  toggle() {
    const fullBio = this.bioTarget.getAttribute("data-full-bio");
    const truncatedBio = this.bioTarget.getAttribute("data-truncated-bio");
    const currentBio = this.bioTarget.innerHTML.trim();

    if (currentBio === truncatedBio.trim()) {
      this.bioTarget.innerHTML = fullBio;
      this.toggleButtonTarget.innerHTML = "-";
    } else {
      this.bioTarget.innerHTML = truncatedBio;
      this.toggleButtonTarget.innerHTML = "+";
    }
  }
}



