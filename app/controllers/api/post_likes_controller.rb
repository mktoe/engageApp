class Api::PostLikesController < ApplicationController
	#ログインしている場合のみ接続許可
	before_action :authenticate_user!	

	#サイドバープロフィール表示用のconcernsモジュール
	include ProfileDisplay
	before_action :profile_display


	def index
		render json: PostLike.filter_by_post(params[:post_id]).select(:id, :profile_id, :post_id)
	end	
	def create
		@p_user.post_like.create!(likes_params)
		
		#headでステータスコードを返す
		head :created
	end	
	def destroy
		@p_user.post_like.find(params[:id]).destroy!

		#headでステータスコードを返す
		head :ok
	end	
	private	
	def likes_params
		params.require(:post_like).permit(:post_id)
	end	
end
