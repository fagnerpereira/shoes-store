require "test_helper"

class SaleTest < ActiveSupport::TestCase
  setup do
    @sale = Sale.new(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 2
    )
  end

  test 'should be valid with store, product and quantity' do
    assert @sale.valid?
  end

  test 'should be valid with duplicated [store, product] scope' do
    Sale.create(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 5
    )
    assert @sale.valid?
  end

  test 'should be invalid with no quantity' do
    @sale.quantity = nil
    assert @sale.invalid?
  end
end
