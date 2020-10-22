# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    products = Product.all.order(id: :desc)
    render json: { data: products, success: true }
  end

  def search
    @result = Product.find_by(url: params[:search])

    # Refetch record in background if record expired
    auto_refresh if @result

    # Fetch record immediately if url is not in database
    @result ||= FetchProductJob.perform_now(params[:search])

    render json: { data: @result, success: true }
  end

  def auto_refresh
    return if @result.expired?

    FetchProductJob.perform_later(params[:search])
  end
end
