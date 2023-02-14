class Sale < ApplicationRecord
  belongs_to :store
  belongs_to :product

  validates :quantity, presence: true
  before_validation :set_metadata

  private

  def set_metadata
    self.metadata = {
      store: { id: store.id, name: store.name },
      product: { id: product.id, name: product.name, price: product.price }
    }
  end
end
