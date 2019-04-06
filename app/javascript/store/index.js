import Vue from 'vue'
import Vuex from 'vuex'
import companyObjective from './modules/companyObjective'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

// 一部抜粋
export default new Vuex.Store({
    modules: {
        companyObjective,
    },
    strict: debug,
});