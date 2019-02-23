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

    private
    def post_comment_params
        params[:post_comment].permit(:profile_id, :post_id, :comment_text, {comment_image: []})
    end


end
