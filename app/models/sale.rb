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
    broadcast_all_sales
    broadcast_top_sales_by_store
    broadcast_top_sales_by_product
  end

  def broadcast_all_sales
    broadcast_replace_later_to(
      'sales',
      partial: 'dashboard/all_sales_chart',
      target: 'all_sales_container'
    )
  end

  def broadcast_top_sales_by_store
    broadcast_replace_later_to(
      'sales',
      partial: 'dashboard/top_sales_by_store_chart',
      target: 'sales_by_store_container'
    )
  end

  def broadcast_top_sales_by_product
    broadcast_replace_later_to(
      'sales',
      partial: 'dashboard/top_sales_by_product_chart',
      target: 'sales_by_product_container'
    )
  end

  def set_metadata
    self.metadata = {
      store: { id: store.id, name: store.name },
      product: { id: product.id, name: product.name, price: product.price }
    }
  end
end
