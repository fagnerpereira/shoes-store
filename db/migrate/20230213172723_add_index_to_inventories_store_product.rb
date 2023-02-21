class AddIndexToInventoriesStoreProduct < ActiveRecord::Migration[7.0]
  def change
    add_index :inventories, %i[store_id product_id], unique: true
  end
end
