<template>
    <div>
        <!--コメントがあった場合に件数と表示ボタンを表示-->
        <div v-if="commentList !='' ">
            <div @click="showComment" class="comment_display_text">コメント{{ commentList.length }}件を表示</div>
        </div>
        
        <transition name="fade">
            <div v-show="show_comment_area" class="post-comment-area">

                <transition-group name="fade" tag="p">
                    <div class="post-comment-block" v-for="(comment,index) in commentList" v-bind:key="index">
                        <div v-if="fetch_profiles[index]">
                            <div class="post-comment-left"> 
                                <span class="post-comment-a-img">
                                <!--profile 画像を表示-->
                                <img v-bind:src="fetch_profiles[index].profile_image.thumb150.url">
                                </span>
                            </div><!--/.post-comment-left-->

                            <div class="post-comment-right">
                                <!--profile 名前を表示-->
                                <span class="post-comment-a-name">{{ fetch_profiles[index].profile_name }}</span>

                                <div v-if="comment.profile_id == profile_id_value">
                                    <!--ログインユーザーコメントを表示-->
                                    <div v-html="replace_text(comment.comment_text)" class="post-comment-a-comment">
                                    </div><!--/.post-comment-a-comment-->
                                    <button v-on:click="deleteComments(comment.id)">削除</button>
                                </div>

                                <div v-else>
                                    <!--コメントを表示-->
                                    <div v-html="replace_text(comment.comment_text)" class="post-comment-a-comment">
                                    </div><!--/.post-comment-a-comment-->
                                </div>
                                
                            </div><!--/.post-comment-right-->

                        </div><!--/.end v-if -->
                    </div><!--/.post-comment-block-->
                </transition-group>

            </div><!--post-comment-area-->
        </transition>
        

        <!--@click.preventでページリロードさせない-->       
        <form @submit.prevent="postCommentCreate" id="new_post_comment" class="form-inline" name="new_post_comment">
            <input type='hidden' name='post_comment[profile_id_value]' v-bind:value="profile_id_value">
            <input type='hidden' name='post_comment[post_id_value]' v-bind:value="post_id_value">
            <textarea v-bind:rows="comment_text.split(/\n/).length" placeholder="コメントする" name='post_comment[comment_text]' v-model='comment_text'></textarea>
            <button type="submit" class='btn btn-primary'>コメントする</button>
        </form>
    </div>
</template>

<script>
// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

export default {
    // propsでrailsのviewからデータを受け取る
    props: ['profileId', 'postId' , 'commentText'],
    data() {
        return {
            //配列のサゴにimgUrlを格納する
            commentList: [],
            profileList: [],
            
            //コメントフォームデータ
            profile_id_value: this.profileId,
            post_id_value: this.postId,
            comment_text: '',

            //コメント表示非表示
            show_comment_area: false
            
        }
    },
    created: function() {
        this.getCommentByPostId(),
        this.getProfiles()
    },

    computed: {
    },

    methods: {
        /*
        全部の情報を配列に格納する
        getComments: function(){
            axios.get(`api/post_comments.json`)
            .then(res => {
                this.commentList = res.data;
            });
        },
        */
        // rails側のindexアクションにリクエストするメソッド
        //commentListにapiで取得したデータを格納
        getCommentByPostId: async function() {
            const res = await axios.get(`/api/post_comments/?post_id=${this.postId}`)
            if (res.status !== 200) { process.exit() }
            return this.commentList = res.data
        },

        //profilesのapiをprofileList格納
        //できればpost_commentのprofile_idと一致したデータのみを配列に格納したい
        getProfiles: function(){
            axios.get(`api/profiles.json`)
            .then(res => {
                this.profileList = res.data;
            })
        },

        // rails側のcreateアクションにリクエストするメソッド
        postCommentCreate: async function() {
            const res = await axios.post('/api/post_comments', { 
                post_id: this.postId,
                profile_id: this.profileId,
                comment_text: this.comment_text
            })
            if (res.status !== 201) { 
                process.exit()
            }
            //フォームの内容をクリア
            this.comment_text = '';

            //表示側のリストに取得したデータを挿入
            this.getCommentByPostId().then(result => {
                this.commentList = result
            }) 
        },

        // 【削除】rails側のdestroyアクションにリクエストするメソッド
        deleteComments: async function(commentId) {
            //確認をとる
            if(confirm('コメントを削除してもいいですか？')){ 
                const res = await axios.delete(`/api/post_comments/${commentId}`)
                if (res.status !== 200) { process.exit() } 
                //配列から該当のコメントを削除
                for(var i =0; i< this.commentList.length; ){
                    if(this.commentList[i].id === commentId){ this.commentList.splice(i,1); continue; }
                    i++;
                }
            }
        },

        //改行とURLを書き換えるメソッド
        replace_text: function(comment){
            var text = comment
            //httpから始まるテキストにaタグをつける
            text = text.replace(/(http(s)?:\/\/[a-zA-Z0-9-.!'()*;/?:@&=+$,%#]+)/gi, "<a href='$1' target='_blank'>$1</a>")
            //改行コードを<br/>に変換
            text = text.replace(/\n/g,'<br/>')
            return text 
        },
        //コメントの表示・非表示　切り替え
        showComment: function(){
            this.show_comment_area = !this.show_comment_area
        }
    },

    //算出プロパティ
    computed: {
        //post_commentsからprofile情報を取得
        fetch_profiles: function() {
        const fetch_profiles = [];
        for (var i = 0; i < this.commentList.length; i++) {
            //post_commentsのprofile_idをdataに格納
            let date = this.commentList[i].profile_id;

            //profileListのidがpost_commentsのidと一致するデータを取得
            //filterを使ってデータを抽出
            let result = this.profileList.filter(function (element) {
                return element.id == date;
            }).shift();

            //定数配列にprosilesのデータを格納
            fetch_profiles.push(result);
        }
        return fetch_profiles;
        }
    } 
}
</script>

<style scoped>
/*transition fade*/
.fade-enter-active, .fade-leave-active {
    will-change: opacity;
    transition: opacity 600ms cubic-bezier(0.4, 0, 0.2, 1) 0ms;
}
.fade-enter, .fade-leave-to {
    opacity: 0
}
/*transition topSlide*/
.top-enter-active, .top-leave-active {
    transform: translate(0px, 0px); 
    transition: transform 600ms cubic-bezier(0, 0, 0.2, 1) 0ms;
}
.top-enter, .top-leave-to {
    transform: translateY(-50px) translateY(0px);
}
.comment_display_text{
    color:#007bff;
    cursor: pointer;
    transition:0.6s;
}
.comment_display_text:hover{
    opacity:0.6;
}
.post-comment-area{
    padding:5px 0;
    border-bottom:1px solid #dddfe2;
    margin-bottom:10px;
    clear:both;
}
.post-comment-block{
    width:100%;
    display: block;
    padding:0px 0 8px 0;
}
.post-comment-block:after{
    content:"";
    display: block;
    width:100%;
    clear: both;
}
.post-comment-left{
    float:left;
    margin-right:10px;
    width:35px;
}
.post-comment-a-img img{
    width: 35px;
    height: 35px;
    object-fit: cover;
    border-radius: 50%; 
    border:1px solid #dddfe2;
}
.post-comment-right{
    float:left;
    max-width: 580px;
}
.post-comment-a-name{
    color:#0097A7;;
    font-size:13px;
    display: block;
}
.post-comment-a-comment{
    background: #f2f3f5;
    padding:5px;
    border-radius:5px;
    font-size:13px !important;
}
</style>


