class Sale < ApplicationRecord
  belongs_to :store, optional: true
  belongs_to :product, optional: true

  validates :quantity, presence: true
  before_validation :set_metadata, on: :create
  after_create_commit :broadcast_later

  def store_name
    metadata.dig 'store', 'name'
  end

  def product_name
    metadata.dig 'product', 'name'
  end

  def price
    metadata.dig 'product', 'price'
  end

  private

  def broadcast_later
    broadcast_prepend_later_to 'sales'
    broadcast_charts_data
  end

  def broadcast_charts_data
    ActionCable.server.broadcast 'charts', {
      created_at:,
      store_name:,
      product_name:
    }
  end

  def set_metadata
    self.metadata = {
      store: { id: store.id, name: store.name },
      product: { id: product.id, name: product.name, price: product.price }
    }
  end
end
