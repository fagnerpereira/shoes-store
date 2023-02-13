class CreateWebhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :webhooks do |t|
      t.integer :status, default: 0, null: false
      t.jsonb :payload

      t.timestamps
    end
  end
end
