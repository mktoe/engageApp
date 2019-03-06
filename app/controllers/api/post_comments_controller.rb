class Api::PostCommentsController < ApplicationController

	#ログインしている場合のみ接続許可
	before_action :authenticate_user!	

	#サイドバープロフィール表示用のconcernsモジュール
	include ProfileDisplay	
	before_action :profile_display

	def index
		#modelでscopeを定義済み
		render json: PostComment.filter_by_post(params[:post_id]).select(:id, :profile_id, :post_id, :comment_text)

	end	

	def new
	end	

	def create
		@p_user.post_comment.create!(comment_params)						
		#headでステータスコードを返す	
		#201 = リソースの生成に成功		
		head :created
	end	

	def edit
	end	

	def update
	end	

	def destroy
		@p_user.post_comment.find(params[:id]).destroy!			
		#headでステータスコードを返す
		#200 = 成功				
		head :ok
	end	

	private
	def comment_params
		params.require(:post_comment).permit(:post_id, :profile_id, :comment_text)
	end	
end
