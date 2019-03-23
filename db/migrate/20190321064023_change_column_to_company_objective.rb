class ChangeColumnToCompanyObjective < ActiveRecord::Migration[5.2]
  def change
    change_column :company_objectives, :company_objective_achieve_rate, :integer, null: false, default: 0
  end
end
