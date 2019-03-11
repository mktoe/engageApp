<template>
<div>

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

            <div v-if="get_profiles(post.profile_id)">
                <div v-if="get_profiles(post.profile_id).user_id === currentUser">
                    <a v-bind:href="'/posts/'+ post.id + '/edit/'">
                        編集
                    </a>
                    <a v-on:click="deletePost(post.id)" class="comment-delete-btn">削除
                    </a>

                    
                </div>
            </div>
            

        </div><!--/.post-avatar-area-->

        <div class="post-block-text">
			<p v-html="post.post_text.replace(/\n/g,'<br/>')"></p>
		</div><!--post-block-text-->

        

    
    </div><!--/.post_block-->
</div><!--/end for -->


</div>
</template>


<script>
// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

export default {
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
            profileList: []
        }
    },
    created: function() {
        this.getPosts(),
        this.getProfiles()
    },

    methods: {
        // rails側のindexアクションにリクエストするメソッド
        //commentListにapiで取得したデータを格納
        getPosts: function(){
            axios.get(`api/posts.json`)
            .then(res => {
                this.postsList = res.data;
            });
        },
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



