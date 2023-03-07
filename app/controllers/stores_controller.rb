class StoresController < ApplicationController
  before_action :set_store, only: %i[show destroy]

  def index
    @stores = Store.all.order(created_at: :desc)
  end

  def new
    @store = Store.new
  end

  def show
    @inventories = @store.inventories.includes(:product)
  end

  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to store_url(@store), notice: "Store was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @store.destroy

    respond_to do |format|
      format.html do
        redirect_to(
          stores_url,
          notice: 'Store was successfully destroyed.'
        )
      end
      format.turbo_stream
    end
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name)
  end
end
