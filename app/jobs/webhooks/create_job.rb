class Webhooks::CreateJob < ApplicationJob
  queue_as :default

  def perform(args)
    webhook = Webhook.new(payload: args)

    if webhook.save
      Webhooks::ProcessJob.perform_later(webhook)
    else
    end
  end
end
