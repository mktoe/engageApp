class Api::PostsController < ApplicationController

	#ログインしている場合のみ接続許可
	before_action :authenticate_user!	

	#サイドバープロフィール表示用のconcernsモジュール
	include ProfileDisplay	
	before_action :profile_display


	def index
	#modelでscopeを定義済み
		render json: Post.all
	end

	def new
	end

	def edit
	end	

	#patchは部分置換
	# PATCH/PUT
	def update
		@post = Post.find_by(id: params[:id])
		@post.post_text = params[:post_text]
		if @post.save
			render json: @post
		else
			render json: @post.errors, status: :unprocessable_entity
		end
	end	

	def destroy
		@post = Post.find_by(id: params[:id])
		@post.destroy
		flash[:notice] = "投稿を削除しました"
		redirect_to("/")			
		
		#headでステータスコードを返す			
		#200 = 成功							
		head :ok
	end	

	private
	def post_params
		params.require(:post).permit(:post_id, :profile_id, :post_text, :post_image)
	end	

end
