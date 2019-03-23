<template>
    <div>
        <b-button variant="primary" class="float-right" v-b-modal.modal-center><i class="fas fa-plus text-white"></i></b-button>

        <!-- Modal Component -->
        <b-modal @click="show=true" v-model="show" id="modal-center" centered hide-footer title="会社目標作成">

            <form @submit.prevent="companyObjectiveCreate">
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
                <button @click="show=false" type="submit" class='btn btn-primary comment-add-btn'>会社目標作成</button>
            </form>

        </b-modal>

        
    </div>
</template>

<script>
// $emitの為にここでimportが必要
import eventHub from '../../packs/company_objective'

// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

export default {
    data() {
        return {
            show: false,

            year: new Date().getFullYear(),
            valueyear: new Date().getFullYear(),
            month: new Date().getMonth() + 1,
            day: new Date().getDate(),
            days_max: '',

            coName: "",
            coDiscription: "",
        }
        
    },
    created: function () {
        this.get_days();
    },
    methods: {
        //日の最大数を取得
        get_days: function () {
            this.days_max = new Date(this.year, this.month, 0).getDate();
        },
        //会社目標の作成
        companyObjectiveCreate: async function() {
            const res = await axios.post('/api/company_objectives', { 
                company_objective_name: this.coName,
                company_objective_complete_date:new Date(this.year, this.month, this.day),
                company_objective_achieve_rate: 0,
                company_objective_discription: this.coDiscription
            })
            if (res.status !== 201) { 
                process.exit()
            }
            eventHub.$emit('send-co', {
                company_objective_name: this.coName,
                company_objective_complete_date:new Date(this.year, this.month - 1, this.day),
                company_objective_achieve_rate: 0,
                company_objective_discription: this.coDiscription
            })
        },
    }
}
</script>