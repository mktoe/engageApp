require 'test_helper'

class CompanyObjectivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_objective = company_objectives(:one)
  end

  test "should get index" do
    get company_objectives_url
    assert_response :success
  end

  test "should get new" do
    get new_company_objective_url
    assert_response :success
  end

  test "should create company_objective" do
    assert_difference('CompanyObjective.count') do
      post company_objectives_url, params: { company_objective: { company_objective_achieve_rate: @company_objective.company_objective_achieve_rate, company_objective_complete_date: @company_objective.company_objective_complete_date, company_objective_discription: @company_objective.company_objective_discription, company_objective_name: @company_objective.company_objective_name } }
    end

    assert_redirected_to company_objective_url(CompanyObjective.last)
  end

  test "should show company_objective" do
    get company_objective_url(@company_objective)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_objective_url(@company_objective)
    assert_response :success
  end

  test "should update company_objective" do
    patch company_objective_url(@company_objective), params: { company_objective: { company_objective_achieve_rate: @company_objective.company_objective_achieve_rate, company_objective_complete_date: @company_objective.company_objective_complete_date, company_objective_discription: @company_objective.company_objective_discription, company_objective_name: @company_objective.company_objective_name } }
    assert_redirected_to company_objective_url(@company_objective)
  end

  test "should destroy company_objective" do
    assert_difference('CompanyObjective.count', -1) do
      delete company_objective_url(@company_objective)
    end

    assert_redirected_to company_objectives_url
  end
end
