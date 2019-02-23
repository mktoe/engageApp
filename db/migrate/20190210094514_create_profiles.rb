class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.integer :user_id, :null => false
      t.string :profile_name, :null => false
      t.datetime :profile_birth
      t.datetime :profile_join_date
      t.string :profile_hobby
      t.text :profile_text

      t.timestamps
    end
  end
end
