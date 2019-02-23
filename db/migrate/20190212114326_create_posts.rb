class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :profile_id
      t.text :post_text

      t.timestamps
    end
  end
end