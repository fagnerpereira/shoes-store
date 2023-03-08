class SalesController < ApplicationController
  before_action :set_sale, only: :show

  def index
    @sales = Sale.all.order(created_at: :desc)
  end

  def show
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end
end
