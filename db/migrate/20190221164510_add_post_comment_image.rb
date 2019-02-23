class AddPostCommentImage < ActiveRecord::Migration[5.2]
  def change
    add_column :post_comments, :comment_image, :string
  end
end
