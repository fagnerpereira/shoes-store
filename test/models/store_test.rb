require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  test 'should create with name' do
    assert Store.new(name: 'store').save
  end

  test 'should create with unique name' do
    Store.create(name: 'storeA')
    assert Store.new(name: 'storeB').save
  end

  test 'should not save without name' do
    store = Store.new
    assert_not store.valid?
  end

  test 'should not save duplicated name' do
    Store.create(name: 'store')
    assert_not Store.new(name: 'store').save
  end
end
