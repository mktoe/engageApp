class Api::ProfilesController < ApplicationController

	#ログインしている場合のみ接続許可
	before_action :authenticate_user!	

	#サイドバープロフィール表示用のconcernsモジュール
	include ProfileDisplay
  	before_action :profile_display


	def index
		#profileのidを取得するscope
		render json: Profile.all
	end	

	def new
	end	

	def create
	end	

	def edit
	end	

	def update
	end	

	def destroy
	end

end
