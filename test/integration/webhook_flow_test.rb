require 'test_helper'

class ReceivedWebhookFlowTest < ActionDispatch::IntegrationTest
  test 'when a webhook is received with correct parameters' do
    store = Store.create(name: 'Store A')
    product = Product.create(name: 'Shoe A')
    inventory = Inventory.create(store:, product:, quantity: 10)

    assert_equal Sale.where(store:, product:).count, 0

    post webhooks_url, params: {
      'store' => 'Store A',
      'model' => 'Shoe A',
      'inventory' => 9
    }

    sale_quantity = inventory.quantity - 9
    assert_equal Sale.where(store:, product:, quantity: sale_quantity).count, 1
    inventory.reload
    assert_equal inventory.quantity, 9
    assert_equal Webhook.last.payload, {
      'store' => 'Store A',
      'model' => 'Shoe A',
      'inventory' => 9
    }
  end
end
