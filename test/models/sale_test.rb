require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  setup do
    @sale = Sale.create(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 1
    )
  end

  test 'should be valid with store, product and quantity' do
    assert @sale.valid?
  end

  test 'should be valid with duplicated [store, product] scope' do
    new_sale = Sale.new(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 1
    )
    assert new_sale.valid?
  end

  test 'should be invalid with no quantity' do
    @sale.quantity = nil
    assert @sale.invalid?
  end

  test 'should nullify if store is destroyed' do
    @sale.store.destroy
    @sale.reload

    assert_nil @sale.store_id
    assert_not_nil @sale.product_id
    assert @sale.valid?
  end

  test 'should nullify if product is destroyed' do
    @sale.product.destroy
    @sale.reload

    assert_nil @sale.product_id
    assert_not_nil @sale.store_id
    assert @sale.valid?
  end

  test 'should return product and store destroyed data' do
    product = @sale.product
    store = @sale.store
    product.destroy
    store.destroy
    @sale.reload

    assert_equal store.name, @sale.store_name
    assert_equal product.name, @sale.product_name
    assert_equal product.price, @sale.price
  end
end
