import 'babel-polyfill'
import Vue from 'vue'

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