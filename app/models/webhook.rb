class Webhook < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  validates :payload, presence: true

  enum status: {
    pending: 0,
    processed: 1,
    failed: 2
  }

  def process!
    Rails.logger.info("[Webhook#process] started #{payload.inspect}")
    transaction do
      Sale.create!(store:, product:, created_at: random_datetime)
      inventory.update!(quantity: payload['inventory'].to_i)
      processed!
      Webhooks::PurgeJob.perform_later(self)
    end
    Rails.logger.info("[Webhook#process] completed #{payload.inspect}")
  rescue StandardError => e
    Rails.logger.error("[Webhook#process] failed #{payload.inspect} with #{e.message}")
  end

  private

  def store
    @store ||= Store.find_by!(name: payload['store'])
  end

  def product
    @product ||= Product.find_by!(name: payload['model'])
  end

  def inventory
    @inventory ||= Inventory.find_by!(store:, product:)
  end

  def random_datetime(days = 7)
    (1..days).to_a.sample.days.ago - (1..1440).to_a.sample.minutes
  end
end
