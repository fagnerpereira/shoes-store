require 'test_helper'

class ReceivedWebhookFlowTest < ActionDispatch::IntegrationTest
  setup do
    @store = stores(:store_a)
    @product = products(:product_a)
    @inventory = Inventory.create(
      store: @store,
      product: @product,
      quantity: 100
    )
  end

  test 'should create in background' do
    assert_enqueued_with(job: Webhooks::CreateJob) do
      post webhooks_url, params: webhook_params
    end
    assert_difference('Webhook.count') do
      perform_enqueued_jobs # performs Webhooks::CreateJob
    end
    assert_equal(Webhook.first.payload, webhook_params)
  end

  private

  def webhook_params
    {
      'store' => @store.name,
      'model' => @product.name,
      'inventory' => '99'
    }
  end
end
