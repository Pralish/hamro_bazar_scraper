# frozen_string_literal: true

class FetchProductJob < ApplicationJob
  queue_as :default

  def perform(url)
    scraped_product = ScraperService.new(url).call

    # Insert or Update record
    product = Product.upsert(scraped_product, unique_by: :url)
    scraped_product
  end
end
