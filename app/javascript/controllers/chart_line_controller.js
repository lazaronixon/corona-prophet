import { Controller } from "stimulus"
import { Chart } from "chart.js"

export default class extends Controller {
  connect() {
    new Chart(this.element, { type: "line", data: this.datasource, options: { animation: false, tooltips: this.tootltips, scales: this.scales } })
  }

  get datasource() {
    return JSON.parse(this.data.get("datasource"))
  }

  get scales() {
    return { xAxes: [{ type: 'time', time: { displayFormats: { day: 'DD/MM' } } }] }
  }

  get tooltips() {
    return { intersect: false }
  }
}
