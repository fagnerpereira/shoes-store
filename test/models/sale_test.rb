require "test_helper"

class SaleTest < ActiveSupport::TestCase
  setup do
    @sale = Sale.new(
      store: stores(:one),
      product: products(:one),
      quantity: 2
    )
  end

  test 'should be valid with store, product and quantity' do
    assert @sale.valid?
  end

  test 'should be valid with duplicated [store, product] scope' do
    Sale.create(
      store: stores(:one),
      product: products(:one),
      quantity: 5
    )
    assert @sale.valid?
  end

  test 'should be invalid with no store' do
    @sale.store = nil
    assert @sale.invalid?
  end

  test 'should be invalid with no product' do
    @sale.product = nil
    assert @sale.invalid?
  end

  test 'should be invalid with no quantity' do
    @sale.quantity = nil
    assert @sale.invalid?
  end
end
