class Api::CompanyObjectivesController < ApplicationController
	#ログインしている場合のみ接続許可
	before_action :authenticate_user!
	#サイドバープロフィール表示用のconcernsモジュール
	include ProfileDisplay
	before_action :profile_display

	def index
		render json: CompanyObjective.all
	end	

	def show
	end	

	def create
		@company_objective = CompanyObjective.new(company_objective_params)

		if @company_objective.save
			render json: @company_objective, status: :created, location: @company_objective
			flash[:notice] = "会社目標を作成しました"
		else
			render json: @company_objective.errors, status: :unprocessable_entity
		end
	end	

	def update
		@company_objective = CompanyObjective.find_by(id: params[:id])
		if @company_objective.update(company_objective_params)
			render json: @company_objective
			flash[:notice] = "会社目標を変更しました"
		else
			render json: @company_objective.errors, status: :unprocessable_entity
		end
	end	
	
	def destroy
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_company_objective
		@company_objective = CompanyObjective.find(params[:id])
	end	
	# Never trust parameters from the scary internet, only allow the white list through.
	def company_objective_params
		params.require(:company_objective).permit(:company_objective_name, :company_objective_complete_date, :company_objective_achieve_rate, :company_objective_discription)
	end
end
