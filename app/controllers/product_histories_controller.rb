require 'json'

class ProductHistoriesController < ApplicationController
  #before_action :set_product_history, only: [:show, :edit, :update, :destroy]

  # GET /product-history/search
  def search
    filter_params = show_params
    @product = ProductHistory.get_historical_data(filter_params[:id], filter_params[:type], filter_params[:timestamp])
    render status: 200, json: @product.to_json
  end

  # POST /product-history
  def create
    csv_file = params[:csv_file].tempfile

    @products = ProductHistory.create_from_file(csv_file, true)

    render status: 200, json: @products.to_json
  end

  private
    def show_params
      params.permit(:id, :type, :timestamp)
    end
end
