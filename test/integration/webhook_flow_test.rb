require 'test_helper'

class ReceivedWebhookFlowTest < ActionDispatch::IntegrationTest
  setup do
    @inventory = Inventory.create(
      store: stores(:store_a),
      product: products(:product_a),
      quantity: 100
    )
  end

  test 'should create and process a webhook in background' do
    assert_enqueued_with(job: Webhooks::CreateJob) do
      post webhooks_url, params: webhook_params
    end
    assert_difference('Webhook.count') do
      assert_enqueued_with(job: Webhooks::ProcessJob) do
        perform_enqueued_jobs # performs Webhooks::CreateJob
      end
    end

    assert_equal(Webhook.first.payload, webhook_params)
    assert_difference -> { Sale.count } => 1, -> { Webhook.count } => -1 do
      perform_enqueued_jobs # performs Webhooks::ProcessJob
    end
    assert_equal(
      @inventory.reload.quantity,
      webhook_params['inventory'].to_i
    )
  end

  private

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
