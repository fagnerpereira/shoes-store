module Webhooks
  class CreateJob < ApplicationJob
    queue_as :default

    def perform(args)
      webhook = Webhook.new(payload: args)
      webhook.save!
    end
  end
end
