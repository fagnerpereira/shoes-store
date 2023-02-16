class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    Webhooks::CreateJob.perform_later(webhook_params)

    head :ok
  end

  private

  def webhook_params
    params.permit(:store, :model, :inventory)
  end
end
