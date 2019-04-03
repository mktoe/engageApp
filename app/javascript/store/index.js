import Vue from 'vue'
import Vuex from 'vuex'
import test from './modules/test.js'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

// 一部抜粋
export default new Vuex.Store({
    modules: {
        test
    },
    strict: debug,
});