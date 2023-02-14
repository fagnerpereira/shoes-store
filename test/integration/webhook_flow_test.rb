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
    assert_nil(created_sale)
    assert_difference('Webhook.count') do
      post webhooks_url, params: webhook_params
    end
    assert_not_nil(created_sale)

    @inventory.reload

    assert_equal(@inventory.quantity, 99)
    assert_equal(Webhook.last.payload, webhook_params)
  end

  def created_sale
    Sale.find_by(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 1
    )
  end

  def webhook_params
    {
      'store' => stores(:store_a).name,
      'model' => products(:product_a).name,
      'inventory' => '99'
    }
  end
end
