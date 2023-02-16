require "test_helper"

class Webhooks::ProcessJobTest < ActiveJob::TestCase
  test 'process a webhook' do
    args = {
      'store' => 'store_name',
      'model' => 'product_name',
      'inventory' => '99'
    }

    webhook = Webhook.create(args)

    Webhooks::ProcessJob.perform_now(webhook)

    webhook.reload

    assert webhook.processed?

  end
end
