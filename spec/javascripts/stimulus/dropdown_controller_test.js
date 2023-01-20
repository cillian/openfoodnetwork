/**
 * @jest-environment jsdom
 */

import { Application } from "stimulus";
import dropdown_controller from "../../../app/webpacker/controllers/dropdown_controller";

describe("DropdownController", () => {
  beforeAll(() => {
    const application = Application.start();
    application.register("dropdown", dropdown_controller);
    jest.useFakeTimers();
  });

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="dropdown">
        <button id="dropdown-button" data-action="dropdown#toggle click@window->dropdown#closeIfClickOutside">
          <i id="dropdown-button-caret" class="icon-caret-down" data-dropdown-target="caret"></i>
        </button>
        <div id="dropdown-content" data-dropdown-target="content" style="display:none">Hello world</div>
      </div>
      <div id="element-outside-dropdown"></div>
    `;
  });

  describe("#toggle", () => {
    it("opens and closes, the caret also changes direction accordingly", () => {
      const dropdownButton = document.getElementById("dropdown-button");
      const dropdownButtonCaret = document.getElementById("dropdown-button-caret");
      const dropdownContent = document.getElementById("dropdown-content");
      expect(dropdownContent.style.display).toBe("none");
      expect(dropdownButtonCaret.className).toBe("icon-caret-down");

      dropdownButton.click();
      jest.runAllTimers();

      expect(dropdownContent.style.display).toBe("block");
      expect(dropdownButtonCaret.className).toBe("icon-caret-up");

      dropdownButton.click();
      jest.runAllTimers();

      expect(dropdownContent.style.display).toBe("none");
      expect(dropdownButtonCaret.className).toBe("icon-caret-down");
    });
  });

  describe("#closeIfClickOutside", () => {
    it("closes when clicking somewhere outside of the dropdown", () => {
      const dropdownButton = document.getElementById("dropdown-button");
      const dropdownContent = document.getElementById("dropdown-content");
      const elementOutsideDropdown = document.getElementById("element-outside-dropdown");
      dropdownButton.click();
      jest.runAllTimers()
      expect(dropdownContent.style.display).toBe("block");

      elementOutsideDropdown.click();
      jest.runAllTimers()

      expect(dropdownContent.style.display).toBe("none");
    });
  });
});
