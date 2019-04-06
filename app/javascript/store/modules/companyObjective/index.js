import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import 'babel-polyfill'

Vue.use(Vuex)

import * as types from '../../mutation-types'

const state = {
    companyObjectives: "",
    loading: true,
    errored: false,
}
const actions = {
    async getCompanyObjectives(context) {
        const payload = {
            companyObjectives: '',
        };
        await axios.get('api/company_objectives.json')
        .then((res) => {
            payload.companyObjectives = res.data;
        })
        .catch(error => {
            console.log(error)
            context.commit('errord')
        })
        .finally(() => context.commit(types.SET_LOADING))
        context.commit(types.GET_COMPANY_OBJECTIVE, payload);
    }

}

const mutations = {
    [types.GET_COMPANY_OBJECTIVE](state, payload) {
        //降順でstateに格納
        state.companyObjectives = payload.companyObjectives.slice().reverse();
    },

    errord (state) {
        // 状態を変更する
        state.errord = true
    },
    [types.SET_LOADING] (state) {
        state.loading = false;
    }
}


export default{
    // commonという名前空間追加
    namespaced: true, 
    state,
    actions,
    mutations,
}

