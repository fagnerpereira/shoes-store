require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'should create with name' do
    assert Product.new(name: 'product').save
  end

  test 'should create with unique name' do
    Product.create(name: 'productA')
    assert Product.new(name: 'productB').save
  end

  test 'should not create without name' do
    assert_not Product.new.save
  end

  test 'should not create without unique name' do
    Product.create(name: 'productA')
    assert_not Product.new(name: 'productA').save
  end
end
