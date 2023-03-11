class SalesController < ApplicationController
  before_action :set_sale, only: :show

  include Pagy::Backend

  def index
    @pagy, @sales = pagy Sale.all.order(created_at: :desc)
    @total = @sales.sum(:price)
  end

  def show; end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end
end
