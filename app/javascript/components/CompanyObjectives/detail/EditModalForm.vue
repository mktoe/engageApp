<template>
    <div>
        <b-button variant="primary" class="float-right" v-b-modal.modal-center><i class="far fa-edit"></i> 編集</b-button>

        <!-- Modal Component -->
        <b-modal @click="show=true" v-model="show" id="modal-center" centered hide-footer title="会社目標作成">
            <form @submit.prevent="update">
                <div class="field">
                    <textarea v-model="coName" placeholder="例：売り上げ昨対120%"></textarea>
                </div>

                <div class="field">
                    <label>達成期限</label>

                    <select v-model="year" @change="get_days">
                        <option v-for="(n,index) in 50" v-bind:key="index" :value="n + (valueyear - 1)">
                        {{ n + (valueyear - 1) }}
                        </option>
                    </select>年
                    
                    <select v-model="month" @change="get_days">
                        <option v-for="(n,index) in 12" v-bind:key="index" :value="n">
                        {{ n }}
                        </option>
                    </select>月

                    <select v-model="day">
                        <option v-for="(n,index) in days_max" v-bind:key="index" :value="n">
                        {{ n }}
                        </option>
                    </select>日

                </div><!--/.field-->
                <div class="field">
                    <label for="company_objective_説明">説明</label>
                    <textarea v-model='coDiscription'></textarea>
                </div>
                <b-button block @click="show=false" type="submit" class='btn btn-primary comment-add-btn'>会社目標を変更</b-button>
            </form>

            <b-button block variant="danger">この会社目標を削除</b-button>
        </b-modal>

        
    </div>
</template>

<script>
// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

export default {
    props: ['coid' , 'coname' , 'completedate' , 'objectivedesc'],
    data() {
        return {
            show: false,

            coName: this.coname,
            completeDate: this.completedate,
            year: new Date(this.completedate).getFullYear(),
            valueyear: new Date().getFullYear(),
            month: new Date(this.completedate).getMonth() + 1,
            day: new Date(this.completedate).getDate(),
            days_max: '',
            coDiscription: this.objectivedesc,
            coId: this.coid,

            //親へ渡す仮データ
            childData: '子コンポーネントのデータ'
        }
        
    },
    created: function () {
        this.get_days();
    },
    methods: {
        //月の最大数を取得
        get_days: function () {
            this.days_max = new Date(this.year, this.month, 0).getDate();
        },
        update: function(postId) {  
        
            const res = axios.patch(`/api/company_objectives/${this.coId}`,{
                company_objective_name: this.coName,
                company_objective_complete_date:new Date(this.year, this.month - 1, this.day),
                //company_objective_achieve_rate: 0,
                company_objective_discription: this.coDiscription
            })
            if (res.status == 200) { process.exit() } 

            // 編集終わったら値を親へ渡す$emit
            this.$emit('send-child-data', {
                company_objective_name: this.coName,
                company_objective_complete_date:new Date(this.year, this.month - 1 , this.day),
                company_objective_discription: this.coDiscription
            })
            
        }
    }   
}
</script>