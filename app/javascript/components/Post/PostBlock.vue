<template>
<div>

<transition-group name="fade" tag="div">
    <div v-for="(post,index) in reversePosts" :key="index">
        <div class="post_block">
            <div class="post-avatar-area">
                <div class="post-circle-avatar">
                    <a v-bind:href="'/profiles/'+ post.profile_id">
                        <img v-if="get_profiles(post.profile_id)" v-bind:src="get_profiles(post.profile_id).profile_image.thumb150.url">
                    </a>
                </div><!--/.post-circle-avatar-->

                <div class="post-avatar-right">
                    <span class="post-a-name">
                        <a v-bind:href="'/profiles/'+ post.profile_id">
                            <div v-if="get_profiles(post.profile_id)">
                                {{ get_profiles(post.profile_id).profile_name }}
                            </div>
                        </a>
                    </span>
                    <span class="post-a-date">
                        {{ post.created_at| moment }}
                    </span>
                </div><!--/.post-avatar-right-->
            </div><!--/.post-avatar-area-->

            <div class="post-edit-area">
                <div v-if="get_profiles(post.profile_id)">
                    <div v-if="get_profiles(post.profile_id).id === currentUser">

                        <div class="dropdown">
                            <a data-toggle="dropdown" href="#"><i class="fas fa-ellipsis-h"></i></a>
                            <ul class="dropdown-menu">
                                <li ><a href="#" v-bind:href="'/posts/'+ post.id + '/edit/'">編集</a></li>
                                <li ><a href="#" v-on:click="deletePost(post.id)">削除</a></li>
                            </ul>
                        </div><!--/.dropdown-->

                    </div>
                </div>
            </div><!--/.post-edit-area-->

            
            <div class="post-block-text">
                <p v-html="post.post_text.replace(/\n/g,'<br/>')"></p>
            </div><!--post-block-text-->

            <div class="post_image_group">

                画像は{{ post.post_image.length }}枚です。
                <div v-for="(item,index) in post.post_image" :key="index">
                    
                    <img class="post_image" v-bind:src="item.url">
                </div>
            </div><!--/.post_image_group-->

            <div v-if="get_profiles(post.profile_id)">
                <!--いいねボタン-->
                <like-button :profile-id="currentUser" :post-id="post.id"></like-button>
                <!--コメント-->
                <post-comment :profile-id="currentUser" :post-id="post.id"></post-comment>
            </div>
        </div><!--/.post_block-->
    </div><!--/end for -->
</transition-group>

<infinite-loading spinner="waveDots" @infinite="infiniteHandler"></infinite-loading>

</div>
</template>


<script>
// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()
//無限スクロール用のライブラリ
import InfiniteLoading from 'vue-infinite-loading'

import LikeButton from './PostLikeButton.vue'
import PostComment from './PostComment.vue'

export default {
    
    components: {
        'like-button' : LikeButton,
        'post-comment' : PostComment,
        InfiniteLoading
    },
    //日本時間の日付フォーマットにフィルター
    filters: {
        moment: function (date) {
            return moment(date).format('YYYY年MM月DD日 HH:mm');// eslint-disable-line
        }
    },
    // propsでrailsのviewからデータを受け取る
    props: ['currentUser'],
    data() {
        return {
            //配列のサゴにimgUrlを格納する
            postsList: [],
            profileList: [],
            page: 1
        }
    },
    created: function() {
        //this.getPosts(),
        this.getProfiles()
    },

    methods: {
        // rails側のindexアクションにリクエストするメソッド
        //commentListにapiで取得したデータを格納
        /*
        getPosts: function(){
            axios.get(`api/posts.json`)
            .then(res => {
                this.postsList = res.data;
            });
        },
        */
    
        //profilesのapiをprofileList格納
        getProfiles: function(){
            axios.get(`api/profiles.json`)
            .then(res => {
                this.profileList = res.data;
            })
        },
        // 【削除】rails側のdestroyアクションにリクエストするメソッド
        deletePost: async function(postId) {
            //確認をとる
            if(confirm('投稿を削除してもいいですか？')){ 
                const res = await axios.delete(`/api/posts/${postId}`)
                if (res.status !== 200) { process.exit() } 
                //配列から該当のコメントを削除
                for(var i =0; i< this.postsList.length; i++ ){
                    if(this.postsList[i].id === postId){ 
                        this.postsList.splice(i,1); 
                        continue; 
                    }
                    
                }
            }
        },

        infiniteHandler($state) {
            setTimeout(() => {
                axios.get( `api/posts.json` , {
                    params: {
                        page: this.page,
                        per_page: 10
                    },
                    headers: {
                        'Authorization' : 'Bearer ' + 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
                    }
                }).then(({ data }) => {
                    if (data.length) {
                    this.page += 1
                    this.postsList.push(...data)
                    $state.loaded()
                    } else {
                    $state.complete()
                    }
                }).catch((err) => {
                    $state.complete()
                })
            }, 1500)
        }
    },
    
    //算出プロパティ
    computed: {
        // 配列の要素順番を逆順にする
        reversePosts() {
            return this.postsList.slice().reverse();
        },
        //投稿のプロフィールユーザー情報を取得
        get_profiles: function() {
            return function (profile_id) {
                //post_commentsのprofile_idをdataに格納
                let result = this.profileList.filter(function (element) {
                    return element.id == profile_id;
                }).shift();

                return result;
            };
            
        }
    }
}
</script>

<style lang="scss" scoped>
/*transition fade*/
.fade-enter-active, .fade-leave-active {
    will-change: opacity;
    transition: opacity 600ms cubic-bezier(0.4, 0, 0.2, 1) 0ms;
}
.fade-enter, .fade-leave-to {
    opacity: 0
}

.post-avatar-area {
    width:70%;
    float:left;
}
.post-edit-area{
    width:30px;
    float:right;
}
.dropdown i.fa-ellipsis-h{
    font-size:1.3em !important;
    color:#707377;
}
.dropdown a{
    display: block;
}
.dropdown a i{
    text-align: center;
}
ul.dropdown-menu{
    transform: translate3d(-100px, 25px, 0px) !important;
    padding:5px 10px;
    box-shadow: 0 0 5px #b8b8b8;
}
ul.dropdown-menu li a{
    display: block;
    padding:5px 0 !important;
}


</style>



