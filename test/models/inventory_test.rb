require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  setup do
    @inventory = Inventory.new(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 100
    )
  end
  test 'should be valid with store, product and quantity' do
    assert @inventory.valid?
  end

  test 'should be valid with unique store and product scope' do
    Inventory.create(
      store: stores(:store_a),
      product: products(:product_b),
      quantity: 100
    )
    assert @inventory.valid?
  end

  test 'should be invalid with no store' do
    @inventory.store = nil
    assert @inventory.invalid?
  end

  test 'should be invalid with no product' do
    @inventory.product = nil
    assert @inventory.invalid?
  end

  test 'should be invalid with no quantity' do
    @inventory.quantity = nil
    assert @inventory.invalid?
  end

  test 'should be invalid with duplicated store and product' do
    Inventory.create(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 100
    )
    assert @inventory.invalid?
  end
end
