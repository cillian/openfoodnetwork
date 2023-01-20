import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["caret", "content"];

  toggle(event) {
    this.caretTarget.classList.toggle("icon-caret-down");
    this.caretTarget.classList.toggle("icon-caret-up");
    this.contentTarget.style.display =
      this.contentTarget.style.display === "none" ? "block" : "none";
  }

  closeIfClickOutside(event) {
    // Close dropdown if click is from a confirm dialog.
    if (
      event.target.closest("a") &&
      event.target.closest("a").dataset.confirm
    ) {
      this.close();
      return;
    }

    // Process click event when click is inside
    if (this.element == event.target || this.element.contains(event.target)) {
      return;
    }

    // Close dropdown when click is outside
    this.close();
  }

  close() {
    this.caretTarget.classList.add("icon-caret-down");
    this.caretTarget.classList.remove("icon-caret-up");
    this.contentTarget.style.display = "none";
  }
}
