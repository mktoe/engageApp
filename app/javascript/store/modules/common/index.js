import Vue from 'vue'
import Vuex from 'vuex'
import 'babel-polyfill'

Vue.use(Vuex)

const state = {
    message: "おっけーだよー"
}

const mutations = {
    //stateの値を変化
    change (state) {
        state.message = "のーだよ"
    }
}

export default{
    // commonという名前空間追加
    namespaced: true, 
    state,
    mutations
}

