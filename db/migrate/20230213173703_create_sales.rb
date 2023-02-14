class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales do |t|
      t.references :store, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.jsonb :data, null: false

      t.timestamps
    end
  end
end
