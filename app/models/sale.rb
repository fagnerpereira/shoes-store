class Sale < ApplicationRecord
  belongs_to :store, optional: true
  belongs_to :product, optional: true

  validates :quantity, presence: true
  before_validation :set_metadata, on: :create
  after_create_commit :broadcast_charts_data

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

  def broadcast_charts_data
    return if Rails.cache.read('charts_cached')

    Rails.cache.write('charts_cached', true, expires_in: 10.seconds)

    broadcast_replace_later_to(
      'sales',
      target: 'all_sales_container',
      partial: 'dashboard/all_sales_chart'
    )

    broadcast_replace_later_to(
      'sales',
      target: 'sales_by_product_container',
      partial: 'dashboard/top_sales_by_product_chart'
    )

    broadcast_replace_later_to(
      'sales',
      target: 'sales_by_store_container',
      partial: 'dashboard/top_sales_by_store_chart'
    )
  end

  def set_metadata
    self.metadata = {
      store: { id: store.id, name: store.name },
      product: {
        id: product.id,
        name: product.name,
        price: product.price
      }
    }
  end
end
