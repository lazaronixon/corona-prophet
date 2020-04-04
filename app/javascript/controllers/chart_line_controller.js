import { Controller } from "stimulus"
import { Chart } from "chart.js"

export default class extends Controller {
  connect() {
    new Chart(this.element, { type: "line", data: this.datasource })
  }

  get datasource() {
    return JSON.parse(this.data.get("datasource"))
  }
}
