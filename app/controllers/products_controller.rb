# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    products = Product.all
    render json: products
  end

  def search
    @result = Product.find_by(url: params[:search])

    # Refetch record in background if record expired
    auto_refresh if @result

    # Fetch record immediately if url is not in database
    @result ||= FetchProductJob.perform_now(params[:search])

    render json: @result
  end

  def auto_refresh
    return if @result.expires_at < Time.now

    FetchProductJob.perform_later(params[:search])
  end
end
