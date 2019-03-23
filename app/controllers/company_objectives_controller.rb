class CompanyObjectivesController < ApplicationController

  #ログインしている場合のみ接続許可
  before_action :authenticate_user!
  #サイドバープロフィール表示用のconcernsモジュール
  include ProfileDisplay
  before_action :profile_display
  
  before_action :set_company_objective, only: [:show, :edit, :update, :destroy]

  # GET /company_objectives
  # GET /company_objectives.json
  def index
    @company_objectives = CompanyObjective.all
  end

  # GET /company_objectives/1
  # GET /company_objectives/1.json
  def show
  end

  # GET /company_objectives/new
  def new
    @company_objective = CompanyObjective.new
  end

  # GET /company_objectives/1/edit
  def edit
  end

  # POST /company_objectives
  # POST /company_objectives.json
  def create
    @company_objective = CompanyObjective.new(company_objective_params)

    respond_to do |format|
      if @company_objective.save
        format.html { redirect_to @company_objective, notice: 'Company objective was successfully created.' }
        format.json { render :show, status: :created, location: @company_objective }
      else
        format.html { render :new }
        format.json { render json: @company_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_objectives/1
  # PATCH/PUT /company_objectives/1.json
  def update
    respond_to do |format|
      if @company_objective.update(company_objective_params)
        format.html { redirect_to @company_objective, notice: 'Company objective was successfully updated.' }
        format.json { render :show, status: :ok, location: @company_objective }
      else
        format.html { render :edit }
        format.json { render json: @company_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_objectives/1
  # DELETE /company_objectives/1.json
  def destroy
    @company_objective.destroy
    respond_to do |format|
      format.html { redirect_to company_objectives_url, notice: 'Company objective was successfully destroyed.' }
      format.json { head :no_content }
    end
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
