import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import 'babel-polyfill'

Vue.use(Vuex)

import * as types from '../mutation-types'

const state = {
    count: 0,
    users: ""
}

const actions = {
    //commitでmutationsへ渡す
    increment (context) {
        context.commit('increment')
    },
    //commitでmutationsへ渡す
    decrement ({ commit }) {
        commit('decrement')
    },
    async getUsers(context) {
        const payload = {
            users: '',
        };
        await axios.get('http://localhost:3000/api/profiles')
        .then((res) => {
            payload.users = res.data;
        });
        //commitでmutationsへ渡す
        context.commit(types.SET_USER, payload);
    },
}

const mutations = {
    //stateの値を変化
    increment (state) {
        state.count += 1
    },
    //stateの値を変化
    decrement (state) {
        state.count -= 1
    },
    //stateの値を変化
    [types.SET_USER](state, payload) {
        state.users = payload.users;
    }
}

const getters = {
    //stateの値を取得コンポーネントへ渡す
    getCount (state) {
        return state.count
    },
    getUser (state) {
        return state.users
    }
}

export default {
    state,
    actions,
    mutations,
    getters
}


/*
const state = {
    
}
const getters = {
    //stateを取得
    
    firstName: state => state.firstName,
    lastName: state => state.lastName,
    users: state => state.users
}
const mutations = {
    [types.UPDATE_MESSAGE](state , newlastName){
        state.lastName = newlastName;
    },
    [types.SET_USER](state, payload) {
        state.users = payload.users;
    }
}
const actions = {
    repeat(context) {
        let lastName = context.state.lastName
        context.commit(test/types.UPDATE_MESSAGE, `${lastName} ${lastName}`)
    },
    async getUsers(context) {
        const payload = {
            users: '',
        };
        await axios.get('http://localhost:3000/api/profiles')
        .then((res) => {
            payload.users = res.data;
        });
        context.commit(test/types.SET_USER, payload);
    },
}
export default new Vuex.Store({
    state: state,
    mutations: mutations,
    actions: actions,
    getters: getters
})
*/

