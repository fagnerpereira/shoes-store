require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:product_a)
  end

  test 'should be valid with name and price' do
    assert @product.valid?
  end

  test 'should be invalid without name' do
    @product.name = nil
    assert @product.invalid?
  end

  test 'should be invalid without price' do
    @product.price = nil
    assert @product.invalid?
  end

  test 'should be invalid without unique name' do
    assert Product.new(name: @product.name).invalid?
  end
end
