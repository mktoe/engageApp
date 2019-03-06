import 'babel-polyfill'
import Vue from 'vue'

// 作成したコンポーネントファイルをimport
import LikeButton from '../components/Post/PostLikeButton.vue'
import PostComment from '../components/Post/PostComment.vue'

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#like',
        components: { 
            'like-button' : LikeButton,
            'post-comment' : PostComment 
        }
    })
})