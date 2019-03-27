<script>
// ここでチャートの種類を選択して...
import { Bar } from 'vue-chartjs'
/**
 * Bar       : 棒グラフ
 * Line      : 折れ線グラフ
 * Doughnut  : ドーナツグラフ
 * Pie       : 円グラフ
 * Radar     : レーダーグラフ
 * Polararea : 極域グラフ
 * Bubble    : バブルグラフ
 * Scatter   : 散布図（mixinでは未対応とのこと）
 **/
export default {
  extends: Bar,
  mounted () {
    // データを流し込むだけ
    this.renderChart({

      labels: ['A','B','C','D','E'],     //ラベル名
      
      datasets: [{
        label: 'チーム目標',
        backgroundColor:[
        "rgba(255, 99, 132, 0.2)",
        "rgba(255, 159, 64, 0.2)",
        "rgba(255, 205, 86, 0.2)",
        "rgba(75, 192, 192, 0.2)",
        "rgba(54, 162, 235, 0.2)"
      ],   //背景色
        data: [5,20,11,2,30],          //データ内容
      }]
    })
  }
}
</script>