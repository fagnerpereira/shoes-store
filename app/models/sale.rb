class Sale < ApplicationRecord
  belongs_to :store, optional: true
  belongs_to :product, optional: true

  validates :quantity, presence: true
  before_validation :set_metadata, on: :create

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

  def set_metadata
    self.metadata = {
      store: { id: store.id, name: store.name },
      product: { id: product.id, name: product.name, price: product.price }
    }
  end
end
