class PostLikesController < ApplicationController
    #ログインしている場合のみ接続許可
    before_action :authenticate_user!
    #サイドバープロフィール表示用のconcernsモジュール
    include ProfileDisplay
    before_action :profile_display


    def create
        @post_like = PostLike.new(
            profile_id: @p_user.id,
            post_id: params[:post_id]
        )
        @post_like.save

        post_like = {'profile_id' => @post_like.profile_id, 'post_id' => @post_like.post_id}
        render json: post_like
    end

    def destroy
        @post_like = PostLike.find_by(profile_id: @p_user.id, post_id: params[:post_id])
        @post_like.destroy

        post_like = {'profile_id' => @post_like.profile_id, 'post_id' => @post_like.post_id}
        render json: post_like
        
        #redirect_to("/posts/#{params[:post_id]}")
    end


end