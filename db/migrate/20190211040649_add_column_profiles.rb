class AddColumnProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :profile_image, :string
    add_column :profiles, :profile_cover_image, :string
  end
end
