class Webhook < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  validates :payload, presence: true

  enum status: {
    pending: 0,
    processed: 1,
    failed: 2
  }

  def process!
    transaction do
      Sale.create!(store:, product:)
      inventory.update!(quantity: payload['inventory'].to_i)
      processed!
    end
  end

  private

  def store
    @store ||= Store.find_by!(name: payload['store'])
  end

  def product
    @product ||= Product.find_by!(name: payload['model'])
  end

  def inventory
    @inventory ||= Inventory.find_by!(store:, product:)
  end
end
