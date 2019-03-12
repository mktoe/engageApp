import 'babel-polyfill'
import Vue from 'vue'

//bootstrap
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import BootstrapVue from 'bootstrap-vue'
Vue.use(BootstrapVue)

// 作成したコンポーネントファイルをimport
import PostBlock from '../components/Post/PostBlock.vue'
import LikeButton from '../components/Post/PostLikeButton.vue'
import PostComment from '../components/Post/PostComment.vue'

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#posts',
        components: { 
            'post-block' : PostBlock,
            'like-button' : LikeButton,
            'post-comment' : PostComment 
        }
    })
})