class AddTotalSalesToStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :total_sales, :float
  end
end
