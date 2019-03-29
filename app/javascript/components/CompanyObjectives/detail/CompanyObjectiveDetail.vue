<template>
    <div class="container">

        <div class="row">
            <div class="col-md-11">
                <p class="o-title"><i class="far fa-flag"></i> 会社目標<br></p>
                <p class="co-title-text">{{ companyObjectiveName }}</p>
                {{ childData }}
            </div>   

            <div class="col-md-1">   
                <!-- 編集ボタン -->
                <edit-modal-form @send-child-data="getChildData" :coid="companyObjectiveId" :coname="companyObjectiveName" :completedate="companyObjectiveCompleteDate" :objectivedesc="companyObjectiveDescription"></edit-modal-form>
            </div>
        </div><!--/.row-->
            
        <div class="row">
            <div class="col-md-5">
                <p class="codate"><i class="far fa-calendar-alt"></i> 達成期日 <span class="codate">{{ dateChange| moment }}</span></p>
                <p class="dl-title"><i class="far fa-clock"></i> 目標達成まであと <span class="deadline">{{ deadLine(dateChange) }}日</span></p>
                <!-- グラフコンポーネント -->
                <detail-circle-graph achieve-rate="companyObjectiveArchiveRate"></detail-circle-graph>
            </div>

            <div class="col-md-7">
                <bar-graph :height='250'></bar-graph>
            </div>
        </div><!--/.row-->

        <div class="desc-area">
            <p class="okr-desc"><i class="far fa-clipboard"></i> この会社目標の説明</p>
            {{ companyObjectiveDescription }}
        </div><!--/.desc-area-->
    </div><!--/.container-->
</template>

<script>
// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

import DetailCircleGraph from './DetailCircleGraph.vue'
import BarGraph from './BarGraph.vue'
import EditModalForm from './EditModalForm.vue'

export default {
    components: {
        'detail-circle-graph' : DetailCircleGraph,
        'bar-graph' : BarGraph,
        'edit-modal-form' : EditModalForm,
    },
    props: ['coid' , 'coname' , 'codate' , 'coarchiverate' , 'codescription'],
    data() {
        return {
            companyObjectiveId: this.coid,
            companyObjectiveName: this.coname,
            companyObjectiveCompleteDate: this.codate,
            companyObjectiveArchiveRate: this.coarchiverate,
            companyObjectiveDescription: this.codescription,

            //子からデータ受け取る為の仮data
            childData: ''
        }
    },
    //日本時間の日付フォーマットにフィルター
    filters: {
        moment: function (date) {
            return moment(date).format('YYYY年MM月DD日');// eslint-disable-line
        }
    },
    methods: {
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
        },
        //子からデータを受け取るメソッド
        getChildData: function(text){
            this.companyObjectiveName = text.company_objective_name;
            this.companyObjectiveCompl = text.company_objective_complete_date;
            this.companyObjectiveDescription = text.company_objective_discription;
        }
    },
    computed: {
        //日付文字列をISOフォーマットに変換
        dateChange: function () {
            return  new Date(this.companyObjectiveCompleteDate);
        },
    }
}

</script>

<style lang="scss" scoped>
p.o-title{
    color:#666666;
    i{
        color:#666666;
    }
}
p.co-title-text{
    font-size:20px;
    margin:8px 0 20px 0;
    font-weight:bold;
    color:#20A3AF;
    line-height:1.4;
}
p.codate{
    margin:8px 0;
    color:#666666;
    i{
        color:#666666;
    }
    span.codate{
        color:#666666;
        margin-left:5px;
    }
}
p.dl-title{
    color:#666666;
    margin:10px 0;
    span.deadline{
        font-size:22px;
        font-weight:bold;
        color:#666666;
    }
    i{
        color:#666666;
    }
}
.desc-area{
    margin:15px 0 0 0;
    padding:15px;
    width:100%;
    p.okr-desc{
        color:#20A3AF;
        font-size:15px;
        font-weight:bold;
        margin:0 0 10px 0;
        i{
            color:#20A3AF;
            font-size:16px;
            font-weight:bold;
        }
    }
}



</style>