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

    # GET /profiles/1/edit
    def edit
        @post = Post.find_by(id: params[:id])
    end

    def update
        @post = Post.find_by(id: params[:id])
        @post.post_text = params[:post_text]
        if @post.save
            flash[:notice] = "投稿を編集しました"
            redirect_to("/")
        else
            render("/")
        end
    end

    def destroy
        @post = Post.find_by(id: params[:id])
        @post.destroy
        flash[:notice] = "投稿を削除しました"
        redirect_to("/")
      end

    private
    def post_params
        params[:post].permit(:profile_id, :post_text, {post_image: []})
        #params[:post].permit(:profile_id, :post_text, :post_image)
    end



end