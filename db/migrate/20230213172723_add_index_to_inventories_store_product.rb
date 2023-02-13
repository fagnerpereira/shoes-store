class AddIndexToInventoriesStoreProduct < ActiveRecord::Migration[7.0]
  def change
    add_index :inventories, [:store_id, :product_id], unique: true
  end
end
