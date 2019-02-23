class PostsController < ApplicationController
    #ログインしている場合のみ接続許可
    before_action :authenticate_user!

    #サイドバープロフィール表示用のconcernsモジュール
    include ProfileDisplay
    before_action :profile_display

    def new
        @post = Post.new
    end

    def create 
        @post = Post.new(post_params)
        if @post.save
            flash[:notice] = "投稿を作成しました"
            redirect_to("/")
        else
            redirect_to("/")
        end
    end

    private
    def post_params
        params[:post].permit(:profile_id, :post_text, {post_image: []})
        #params[:post].permit(:profile_id, :post_text, :post_image)
    end



end