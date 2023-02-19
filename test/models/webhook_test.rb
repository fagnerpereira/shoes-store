require 'test_helper'

class WebhookTest < ActiveSupport::TestCase
  setup do
    @product = products(:product_a)
    @store = stores(:store_a)
    @inventory = Inventory.create(
      store: @store,
      product: @product,
      quantity: 100
    )
    @webhook = Webhook.create(
      payload: {
        'store' => @store.name,
        'model' => @product.name,
        'inventory' => '99'
      }
    )
  end

  test 'should process' do
    assert_difference('Sale.count') do
      @webhook.process!
    end
    assert @webhook.reload.processed?
    assert_equal @inventory.reload.quantity, 99
  end
end
