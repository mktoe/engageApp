require "application_system_test_case"

class CompanyObjectivesTest < ApplicationSystemTestCase
  setup do
    @company_objective = company_objectives(:one)
  end

  test "visiting the index" do
    visit company_objectives_url
    assert_selector "h1", text: "Company Objectives"
  end

  test "creating a Company objective" do
    visit company_objectives_url
    click_on "New Company Objective"

    fill_in "Company objective achieve rate", with: @company_objective.company_objective_achieve_rate
    fill_in "Company objective complete date", with: @company_objective.company_objective_complete_date
    fill_in "Company objective discription", with: @company_objective.company_objective_discription
    fill_in "Company objective name", with: @company_objective.company_objective_name
    click_on "Create Company objective"

    assert_text "Company objective was successfully created"
    click_on "Back"
  end

  test "updating a Company objective" do
    visit company_objectives_url
    click_on "Edit", match: :first

    fill_in "Company objective achieve rate", with: @company_objective.company_objective_achieve_rate
    fill_in "Company objective complete date", with: @company_objective.company_objective_complete_date
    fill_in "Company objective discription", with: @company_objective.company_objective_discription
    fill_in "Company objective name", with: @company_objective.company_objective_name
    click_on "Update Company objective"

    assert_text "Company objective was successfully updated"
    click_on "Back"
  end

  test "destroying a Company objective" do
    visit company_objectives_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Company objective was successfully destroyed"
  end
end
