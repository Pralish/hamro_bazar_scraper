# frozen_string_literal: true

class ProductsController < ApplicationController

  before_action :validate_url, only: :search

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

  private

  def auto_refresh
    return if @result.expired?

    FetchProductJob.perform_later(params[:search])
  end

  def validate_url
    return if params[:search].match(%r{https://hamrobazaar.com/(.*).html}).present?

    raise CustomExceptions::InvalidUrl, 'Url must be a hamro bazar ad url'
  end
end
