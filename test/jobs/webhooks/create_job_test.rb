require 'test_helper'

class Webhooks::CreateJobTest < ActiveJob::TestCase
  test 'create a webhook' do
    args = {
      'store' => 'store_name',
      'model' => 'product_name',
      'inventory' => '99'
    }

    assert_enqueued_with(job: Webhooks::ProcessJob) do
      Webhooks::CreateJob.perform_now(args)
    end

    created_webhook = Webhook.first

    assert created_webhook.pending?
    assert_equal args, created_webhook.payload
    assert_enqueued_jobs 1
  end
end
