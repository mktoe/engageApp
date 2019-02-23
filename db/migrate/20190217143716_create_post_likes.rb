class CreatePostLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :post_likes do |t|
      t.integer :post_id
      t.integer :profile_id

      t.timestamps
    end
  end
end
