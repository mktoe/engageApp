<template>
<div>

    <section v-if="errored">
        <p>データ接続エラー</p>
    </section>

    <section v-else>
    <div v-if="loading" class="loader">Loading...</div>

<transition-group name="fade" tag="div">
    <div v-for="(objective,index) in reverseCo" :key="index" class="col-md-4">
        <a v-bind:href="'company_objectives/' + objective.id">

    
            <div class="co-block">
                会社目標
                <p class="text-dark co-title-text">{{ objective.company_objective_name }}</p>

        <span class="objective-a-date">
            目標期日
            {{ objective.company_objective_complete_date| moment }}<br>
        </span>

        <span class="objective-a-date">
            目標達成まであと
            {{ deadLine(objective.company_objective_complete_date) }}日<br>
        </span>
        
        
        <!-- グラフコンポーネント -->
        <circle-graph :achieve-rate="objective.company_objective_achieve_rate"></circle-graph><br>
            
        </div><!--/.co-block-->

        </a>
    

    </div><!--/end for -->
</transition-group>


</section>



    
</div>
</template>

<script>
// $onの為にここでimportが必要
import eventHub from '../../packs/company_objective'

// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

import CircleGraph from './CircleGraph.vue'

export default {
    components: {
        'circle-graph' : CircleGraph,
    },
    data() {
        return {
            text: "ああああ",
            coList:[],
            loading: true,
            errored: false
        }
    },
    //日本時間の日付フォーマットにフィルター
    filters: {
        moment: function (date) {
            return moment(date).format('YYYY年MM月DD日');// eslint-disable-line
        }
    },
    created () {
        // どこから来るかわからないけど`send-text`イベントを待ち受ける
        eventHub.$on('send-co', this.changeText)
    },
    methods: {
        changeText: function(text) {
            //表示側のリストに取得したデータを挿入
            //表示側のリストに取得したデータを挿入
            this.coList.push(text);
        },
        //目標期日までの日数を返す算出
        deadLine(date){
            //現在の日付のミリ秒
            let nowDate = new Date();
            let dnum = nowDate.getTime();
            //目標日付のミリ秒
            let cDate = new Date(date);
            let cDateTime = cDate.getTime();
            //目標日までのミリ秒を日数に変換
            let days = Math.floor((cDateTime - dnum) / (1000*60*60*24));
            return days;
        }
    },
    mounted(){
        //companyobjectsデータをapiから取得
        axios
        .get(`api/company_objectives.json`)
        .then(response => {
            this.coList = response.data;
            //取得したらローディング終了
            this.loading = false;
        })
        //api取得のエラー処理
        .catch(error => {
            console.log(error)
            this.errored = true
        })
        .finally(() => this.loading = false)
    },
    //算出プロパティ
    computed: {
        // 配列の要素順番を逆順にする
        reverseCo() {
            return this.coList.slice().reverse();
        }
    }
}

</script>

<style lang="scss" scoped>
#company-objectives{
    width:100%;
    .co-block{
        background: #fff;
        padding:15px;
        margin-top:15px;
        margin-bottom:15px;
        font-size: 12px;
        position: relative;
        overflow: hidden;
        color: #666;
        -webkit-box-shadow: 4px 4px 40px rgba(0,0,0,.1);
        box-shadow: 4px 4px 40px rgba(0,0,0,.1);
        border-color: rgba(0,0,0,.05);
        height:300px;
        width:100%;
        /*box-shadow:0 4px 70px -18px #707070;*/
        transition: 0.6s;
        &:hover{
            transition: 0.6s;
            background: #f5f5f5;
            cursor: pointer;
        }
        p.co-title-text{
            font-size:18px;
            margin:3px 0 10px 0;
            font-weight:bold;
        }
    }
    .col-md-4 {
        float: left;
    }
}
.fade-enter-active, .fade-leave-active {
    will-change: opacity;
    transition: opacity 600ms cubic-bezier(0.4, 0, 0.2, 1) 0ms;
}
.fade-enter, .fade-leave-to {
    opacity: 0
}

</style>