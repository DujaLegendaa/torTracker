import Chart from "chart.js/auto"
import 'chartjs-adapter-luxon'
import ChartStreaming from "chartjs-plugin-streaming"
Chart.register(ChartStreaming)

export default class {
  constructor(ctx) {
    const config = {
      type: "line",
      data: {
        datasets: [
          {
            label: "Read",
            data: [],
            borderColor: "#ef9fbc"
          },
          {
            label: "Write",
            data: [],
            borderColor: "#eeaf3a"
          }
        ]
      },
      options: {
        datasets: {
          line: {
            tension: 0.3
          }
        },
        plugins: {
          streaming: {
            duration: 60 * 1000,
            delay: 1500
          }
        },
        scales: {
          x: {
            type: "realtime"
          },
          y: {

          }
        }
      }
    }

    this.chart = new Chart(ctx, config)
  }

  addPoint(label, value) {
    const dataset = this._findDataset(label)
    dataset.data.push({x: Date.now(), y: value})
    this.chart.update()
  }

  _findDataset(label) {
    return this.chart.data.datasets.find((dataset) => dataset.label == label)
  }

}
