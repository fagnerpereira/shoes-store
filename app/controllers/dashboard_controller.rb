class DashboardController < ApplicationController
  FILTER_INTERVAL = {
    daily: 'group_by_day',
    weekly: 'group_by_week',
    monthly: 'group_by_month'
  }.freeze
  DEFAULT_DAYS_TO_FILTER = 7
  DEFAULT_INTERVAL_FILTER = :daily

  before_action :set_sales_charts

  def sales_by_stores
    data = sales.send(FILTER_INTERVAL[filter_interval], :created_at)
                .sum(:price)

    render json: data.to_json
  end

  def top_sales_by_stores
    data = sales.joins(:store)
                .group('stores.name')
                .count
                .sort_by { |_, count| count }.reverse

    render json: data.to_json
  end

  def top_sales_by_products
    data = sales.joins(:product)
                .group('products.name')
                .count
                .sort_by { |_, count| count }.reverse

    render json: data.to_json
  end

  private

  def set_sales_charts
    @total = sales.sum(:price)
  end

  def sales
    @sales ||= Sale.where(
      created_at: filter_days.days.ago..Time.current
    )
  end

  def filter_days
    (params[:filter_days] || DEFAULT_DAYS_TO_FILTER).to_i
  end

  def filter_interval
    (params[:filter_interval]&.to_sym || DEFAULT_INTERVAL_FILTER)
  end
end
