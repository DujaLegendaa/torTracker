import Chart from "chart.js/auto"
export default function make_chart(element) {
  const ctx = element.getContext('2d')
  const chart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
      datasets: [
        {
          label: 'Read',
          data: [100, 200, 300, 100, 200, 300, 100, 200, 300, 400],
          borderColor: '#5a95eb',
        },
        {
          label: 'Write',
          data: [300, 200, 100, 300, 200, 100, 300, 200, 100, 400],
          borderColor: '#8deb98',
        },
      ],
    },
    options: {
      animation: false,
      responsive: false,
      maintainAspectRatio: false,
        scales: {
          xAxis: {
            //type: "time",
            ticks: {
              autoSkip: true,
              maxTicksLimit: 5
            }
          }
        }
    }
  })
}
