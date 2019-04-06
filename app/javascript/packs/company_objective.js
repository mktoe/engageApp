import 'babel-polyfill'
import Vue from 'vue'

//bootstrap
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import BootstrapVue from 'bootstrap-vue'
Vue.use(BootstrapVue)

// 作成したコンポーネントファイルをimport
import ObjectiveBlock from '../components/CompanyObjectives/ObjectiveBlock.vue'
import ModalForm from '../components/CompanyObjectives/ModalForm.vue'

import CompanyObjectiveDetail from '../components/CompanyObjectives/detail/CompanyObjectiveDetail.vue'

import store from '../store'

import iView from 'iview';
import 'iview/dist/styles/iview.css';
Vue.use(iView);

var eventHub = new Vue();
export default eventHub;

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        store,
        el: '#company-objectives',
        components: { 
            'objective-block' : ObjectiveBlock,
            'modal-form' : ModalForm,
            'company-objective-detail' : CompanyObjectiveDetail
        }
    })
})