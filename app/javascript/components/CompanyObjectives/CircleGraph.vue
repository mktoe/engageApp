<template>
<div>
    <div class="circle-parent-box">
        <svg class="circle-graph" width="130" height="130" xmlns="http://www.w3.org/2000/svg" style="transform: rotate(-90deg)">
            <circle cx="65" cy="65" r="60" v-bind:stroke-dasharray="formatTime" />
        </svg>
        <p class="circle-graph-num"><span>{{ resultTime }}</span> %</p>
    </div><!--/.circle-parent-box-->
</div>
</template>

<script>
    export default {
        props: ['achieveRate'],
        data() {
            return {
                //percent_set: Math.ceil(this.achieveRate * 3.77), 本来はこちら
                percent_set: Math.ceil(70 * 3.77), // 達成率に3.77をかけて小数点切り捨て
                percent_fill: 0,
                percent_none: 377, //100%が377
                timerObj: null,
            }
        },
        mounted() {
            window.addEventListener('load', this.graph);
        },
        methods: {
            graph: function () {
                let self = this;
                self.timerObj = setInterval(function () {
                    self.percent_fill++
                    self.percent_none--
                    if ((self.percent_none == 0) || self.percent_fill == self.percent_set) {
                        clearInterval(self.timerObj)
                    }
                }, 0.1)
            }
        },
        computed: {
            formatTime: function () {
                let timeStrings = [this.percent_fill.toString(), this.percent_none.toString()]
                return timeStrings[0] + ',' + timeStrings[1]
            },
            //%の表示
            resultTime: function () {
                return Math.floor( this.percent_fill / 3.77);
            }
        }
    }
</script>

<style lang="scss" scoped>
circle{
    fill:transparent;
    stroke: #00BCD4;
    stroke-width: 10px;
    stroke-linecap:round;
    /*animation: circle 1s infinite;*/
}
svg.circle-graph{
    display: block;
    margin-top:0;
    margin-bottom:0;
    margin: 0 auto;
}
.circle-parent-box{
    position:relative;
    width:130px;
    height:130px;
    margin: 0 auto;
}
p.circle-graph-num{
    position:absolute;
    top:50%;
    left:50%;
    transform: translate(-50%,-50%);
}
p.circle-graph-num span{
    font-size:18px;
}
/*
@keyframes circle {
    0% { 
        stroke-dasharray: 0 377; 
    }
    99.9%,to { 
        stroke-dasharray: 377 377; 
    }
}
*/
</style>
