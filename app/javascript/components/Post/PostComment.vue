<template>
    <div>
        <div v-if="commentList !='' ">
            <i class="fas fa-comment"></i> {{ commentList.length }}
        </div>
        <div v-else>
            <i class="far fa-comment"></i>
        </div>
        
        <div v-if="commentList !='' " class="post-comment-area">
            <transition-group name="fade" tag="div">   

            <!--コメントが5件以上の場合-->
            <div v-for="(comment , index) in commentList" v-bind:key="comment.id">

                    <div class="comment_hidden post-comment-block" v-if="index >= 5" v-show="show_comment_area">
                        <div class="post-comment-left"> 
                            <span class="post-comment-a-img">
                                <!--profile 画像を表示-->
                                <img v-if="fetch_profiles[index]" v-bind:src="fetch_profiles[index].profile_image.thumb150.url">
                                </span>
                        </div><!--/.post-comment-left-->
                        <div class="post-comment-right">
                            <!--profile 名前を表示-->
                            <span v-if="fetch_profiles[index]" class="post-comment-a-name">{{ fetch_profiles[index].profile_name }}</span>

                            <div v-if="comment.profile_id == profile_id_value">
                                <!--ログインユーザーコメントを表示-->
                                <div v-html="replace_text(comment.comment_text)" class="post-comment-a-comment">
                                </div><!--/.post-comment-a-comment-->
                                <!--削除ボタン-->
                                <div class="delete-btn-area">
                                    <button v-on:click="deleteComments(comment.id)" class="comment-delete-btn"><i class="far fa-trash-alt"></i>
                                    </button>
                                    <p class="arrow_box">削除</p>
                                </div>
                            </div>

                            <div v-else>
                                <!--コメントを表示-->
                                <div v-html="replace_text(comment.comment_text)" class="post-comment-a-comment">
                                </div><!--/.post-comment-a-comment-->
                            </div>
                        </div><!--/.post-comment-right-->
                    </div>

                    <!--コメントが5件以下の場合-->
                    <div v-else class="post-comment-block">

                        <div class="post-comment-left"> 
                            <span class="post-comment-a-img">
                                <!--profile 画像を表示-->
                                <img v-if="fetch_profiles[index]" v-bind:src="fetch_profiles[index].profile_image.thumb150.url">
                                </span>
                        </div><!--/.post-comment-left-->
                        <div class="post-comment-right">
                            <!--profile 名前を表示-->
                            <span v-if="fetch_profiles[index]" class="post-comment-a-name">{{ fetch_profiles[index].profile_name }}</span>

                            <div v-if="comment.profile_id == profile_id_value">
                                <!--ログインユーザーコメントを表示-->
                                <div v-html="replace_text(comment.comment_text)" class="post-comment-a-comment">
                                </div><!--/.post-comment-a-comment-->
                                <!--削除ボタン-->
                                <div class="delete-btn-area">
                                    <button v-on:click="deleteComments(comment.id)" class="comment-delete-btn"><i class="far fa-trash-alt"></i>
                                    </button>
                                    <p class="arrow_box">削除</p>
                                </div>
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


            <div v-if="commentList.length >= 5">
                <div v-on:click="showComment" v-show="show_comment_triger" class="comment_display_text">すべてのコメントを表示</div>
            </div>

        </div><!--post-comment-area-->

        
        <!--コメント入力フォーム--> 
        <!--@click.preventでページリロードさせない-->
        <transition name="fade">
            <div class="post-comment-block">
            <div class="post-comment-left"> 
                <span class="post-comment-a-img">
                <!--profile 画像を表示-->
                <img v-if="get_profiles" v-bind:src="get_profiles.thumb150.url">
                </span>
            </div><!--/.post-comment-left-->

            <div class="post-comment-right">
                <form @submit.prevent="postCommentCreate" id="new_post_comment" class="form-inline" name="new_post_comment">
                    <input type='hidden' name='post_comment[profile_id_value]' v-bind:value="profile_id_value">
                    <input type='hidden' name='post_comment[post_id_value]' v-bind:value="post_id_value">
                    <textarea v-bind:rows="comment_text.split(/\n/).length" placeholder="コメントする" name='post_comment[comment_text]' v-model='comment_text'></textarea>
                    <button type="submit" class='btn btn-primary comment-add-btn'>コメント投稿</button>
                </form>  
            </div><!--/.post-comment-right-->
            </div>
        </transition>  
        
        
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
            show_comment_area: false,
            show_comment_triger: true
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

            this.show_comment_area = true
            this.show_comment_triger = false

        },

        // 【削除】rails側のdestroyアクションにリクエストするメソッド
        deleteComments: async function(commentId) {
            //確認をとる
            if(confirm('コメントを削除してもいいですか？')){ 
                const res = await axios.delete(`/api/post_comments/${commentId}`)
                if (res.status !== 200) { process.exit() } 
                //配列から該当のコメントを削除
                for(var i =0; i< this.commentList.length; i++){
                    if(this.commentList[i].id === commentId){ this.commentList.splice(i,1); continue; }
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
            this.show_comment_triger = false
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
        },

        //ログインしているユーザーの情報を取得
        get_profiles: function() {
            for (var i = 0; i < this.profileList.length; i++) {
                //post_commentsのprofile_idをdataに格納
                let date = this.profileList[i].id;
                if(this.profileId == date){
                    return this.profileList[i].profile_image
                }
            }
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
    clear:both;
}
.comment_display_text:hover{
    opacity:0.6;
}
.post-comment-area{
    padding:5px 0;
    margin:10px 0 0 0;
    clear:both;
}
.post-comment-block{
    width:100%;
    display: block;
    padding:8px 0 8px 0;
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
    width: calc(100% - 45px);
}
.post-comment-a-name{
    color:#0097A7;;
    font-size:13px;
    display: block;
}
.post-comment-a-comment{
    padding:5px;
    border-radius:5px;
    font-size:13px !important;
}

.delete-btn-area{
    position:relative;
}
button.comment-delete-btn{
    background: transparent;
    border-style:none;
    display: block;
    cursor: pointer;
}
button.comment-delete-btn i{
    color:#dcdcdc !important;
    font-size:15px;
    margin-top:5px;
}
button.comment-delete-btn:focus {
    outline: 0;
}
.arrow_box {
    opacity:0;
    display: none;
    transition: all 0.3s ease 0s;
    position: absolute;
    padding: 0.2em 0.7em;
    -webkit-border-radius: 8px;
    -moz-border-radius: 8px;  
    border-radius: 8px;
    background: #333;
    color: #fff;
    font-size:13px;
    left:-5px;
}
button.comment-delete-btn:hover + p.arrow_box {
    top: 26px;/*HOVER位置*/
    opacity: 1;
    display: block;
}



form#new_post_comment{
    border:solid 1px #d8d8d8;
    border-radius: 8px;
    color: #9b9b9b;
    height: auto;
    padding: 10px 13px 40px 10px;
    resize: none;
    word-wrap: break-word;
    position:relative;
}
form#new_post_comment textarea{
    width:100%;
    resize:none;
    border-style:none;
    margin-bottom:5px;
    border-radius:5px;
}
form#new_post_comment textarea::placeholder{
    color:#ccc;
}
form#new_post_comment textarea:focus {
    outline: 0;
}
button.comment-add-btn{
    width:auto;
    background:#00BCD4;
    outline: 0;
    border-style:none;
    height:30px;
    font-size:10px;
    position:absolute;
    right:13px;
    bottom:10px;
}
i.fa-comment{
    margin-left:10px;
    color:#0097A7;
}



</style>


