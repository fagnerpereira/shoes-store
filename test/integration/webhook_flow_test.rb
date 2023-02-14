require 'test_helper'

class ReceivedWebhookFlowTest < ActionDispatch::IntegrationTest
  setup do
    @inventory = Inventory.create(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 100
    )
  end

  test 'should create a webhook and then process it' do
    assert_nil(
      Sale.find_by(
        store: stores(:store_a),
        product: products(:product_a),
        quantity: 1
      )
    )
    assert_difference('Webhook.count') do
      post webhooks_url, params: {
        'store' => stores(:store_a).name,
        'model' => products(:product_a).name,
        'inventory' => 99
      }
    end

    assert_not_nil(
      Sale.find_by(
        store: stores(:store_a),
        product: products(:product_a),
        quantity: 1
      )
    )

    @inventory.reload

    assert_equal @inventory.quantity, 99
    assert_equal(
      Webhook.last.payload, {
        'store' => stores(:store_a).name,
        'model' => products(:product_a).name,
        'inventory' => '99'
      }
    )
  end
end
