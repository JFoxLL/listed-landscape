import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["bio", "toggleButton"];
  
  toggle() {
    console.log("Entering toggle function");

    const fullBio = this.bioTarget.getAttribute("data-full-bio");
    console.log(`Full Bio: ${fullBio}`);

    const truncatedBio = this.bioTarget.getAttribute("data-truncated-bio");
    console.log(`Truncated Bio: ${truncatedBio}`);

    const currentBio = this.bioTarget.innerHTML.trim();
    console.log(`Current bio content: ${currentBio}`);

    if (currentBio === truncatedBio.trim()) {
      console.log("Switching to full bio");
      this.bioTarget.innerHTML = fullBio;
      this.toggleButtonTarget.innerHTML = "Show Less";
    } else {
      console.log("Switching to truncated bio");
      this.bioTarget.innerHTML = truncatedBio;
      this.toggleButtonTarget.innerHTML = "Read More";
    }

    console.log("Exiting toggle function");
  }
}


