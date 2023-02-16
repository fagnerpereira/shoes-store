class Webhook < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  enum status: {
    pending: 0,
    processed: 1,
    failed: 2
  }
end
