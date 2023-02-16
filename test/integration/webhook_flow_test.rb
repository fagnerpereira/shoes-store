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
    assert_enqueued_with(job: Webhooks::CreateJob) do
      post webhooks_url, params: webhook_params
    end
    assert_difference('Webhook.count') do
      assert_enqueued_with(job: Webhooks::ProcessJob) do
        # performs Webhooks::CreateJob
        perform_enqueued_jobs
      end
    end
    assert_difference('Sale.count') do
      # performs Webhooks::ProcessJob
      perform_enqueued_jobs
    end

    @inventory.reload

    assert_equal(@inventory.quantity, webhook_params['inventory'].to_i)
    assert_equal(Webhook.first.payload, webhook_params)
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
