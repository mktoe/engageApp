class CreateCompanyObjectives < ActiveRecord::Migration[5.2]
  def change
    create_table :company_objectives do |t|
      t.string :company_objective_name
      t.datetime :company_objective_complete_date
      t.integer :company_objective_achieve_rate
      t.text :company_objective_discription

      t.timestamps
    end
  end
end
