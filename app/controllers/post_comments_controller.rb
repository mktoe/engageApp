class PostCommentsController < ApplicationController
    #ログインしている場合のみ接続許可
    before_action :authenticate_user!

    #サイドバープロフィール表示用のconcernsモジュール
    include ProfileDisplay
    before_action :profile_display
    

    def new
        @post_comment = PostComment.new
    end

    def create 
        @post_comment = PostComment.new(post_comment_params)
        if @post_comment.save
            flash[:notice] = "コメントを作成しました"
            redirect_to("/")
        else
            redirect_to("/")
        end
    end

    # GET /profiles/1/edit
    def edit
        @post_comment = PostComment.find_by(id: params[:id])
    end

    def update
        @post_comment = PostComment.find_by(id: params[:id])
        @post_comment.comment_text = params[:comment_text]
        if @post_comment.save
            flash[:notice] = "投稿を編集しました"
            redirect_to("/")
        else
            render("/")
        end
    end

    def destroy
        @post_comment = PostComment.find_by(id: params[:id])
        @post_comment.destroy
        flash[:notice] = "投稿を削除しました"
        redirect_to("/")
    end

    private
    def post_comment_params
        params[:post_comment].permit(:profile_id, :post_id, :comment_text, {comment_image: []})
    end


end
