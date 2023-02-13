require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  test 'should not save without name' do
    store = Store.new
    assert_not store.save
  end

  test 'should not save duplicated name' do
    Store.create(name: 'store')
    assert_not Store.new(name: 'store').save
  end
end
