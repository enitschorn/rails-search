import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["startDate", "endDate"];
  connect() {
    const startPicker = this.startDateTarget.flatpickr({
      disable: JSON.parse(this.element.dataset.unavailable),
      minDate: "today",
      onChange: function (selectedDates, dateStr, instance) {
        endPicker.set("minDate", dateStr);
      },
    });
    const endPicker = this.endDateTarget.flatpickr({
      disable: JSON.parse(this.element.dataset.unavailable),
      minDate: "today",
      onChange: function (selectedDates, dateStr, instance) {
        startPicker.set("maxDate", dateStr);
      },
    });
  }
}
