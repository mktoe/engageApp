<template>
    <div class="container">
            会社目標
            {{ companyObjectiveName }}
            <br>

            達成期日
            {{ dateChange| moment }}
            <br>
        <div class="row">
            <div class="col-md-6">
                達成率
                <!-- グラフコンポーネント -->
                <detail-circle-graph :achieve-rate="companyObjectiveArchiveRate"></detail-circle-graph>
            </div>
            <div class="col-md-6">
                達成率
                <!-- グラフコンポーネント -->
                <detail-circle-graph :achieve-rate="companyObjectiveArchiveRate"></detail-circle-graph>
            </div>

        </div><!--/.row-->

            会社目標の説明
            {{ companyObjectiveDescription }}
    </div><!--/.container-->
</template>

<script>
// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

import DetailCircleGraph from './DetailCircleGraph.vue'

export default {
    components: {
        'detail-circle-graph' : DetailCircleGraph,
    },
    props: ['coname' , 'codate' , 'coarchiverate' , 'codescription'],
    data() {
        return {
            companyObjectiveName: this.coname,
            companyObjectiveCompleteDate: this.codate,
            companyObjectiveArchiveRate: this.coarchiverate,
            companyObjectiveDescription: this.codescription
        }
    },
    //日本時間の日付フォーマットにフィルター
    filters: {
        moment: function (date) {
            return moment(date).format('YYYY年MM月DD日');// eslint-disable-line
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


</style>