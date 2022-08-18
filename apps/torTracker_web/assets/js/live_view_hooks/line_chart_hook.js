import RealTimeChart from "../line_chart"

export default {
  mounted() {
    this.chart = new RealTimeChart(this.el)

    this.handleEvent("new_point:" + this.el.id, ({label, value}) => {
      this.chart.addPoint(label, value)
    })
  }
}
