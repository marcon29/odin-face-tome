class AddColumnsToActiveStorageBlobs < ActiveRecord::Migration[6.1]
  def change
    add_column :active_storage_blobs, :fit, :string
    add_column :active_storage_blobs, :position, :string
    add_column :active_storage_blobs, :horiz_pos, :integer
    add_column :active_storage_blobs, :vert_pos, :integer
    add_column :users, :oauth_default, :boolean
  end
end
