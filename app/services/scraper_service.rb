# frozen_string_literal: true

require 'open-uri'

class ScraperService
  def initialize(url)
    @url = url
    @now = Time.zone.now
  end

  def call
    scrape
  end

  private

  attr_reader :url, :now

  def scrape
    content = URI.open(@url, 'User-Agent' => "Ruby/#{RUBY_VERSION}")
    html = Nokogiri::HTML(content)

    if html.at_xpath('//div/b[contains(text(), "Ad expired or removed")]')
      handle_removed_ad
    end

    {
      url: @url,
      title: html.css('.title').text,
      price: html.xpath('//td[contains(text(), "Price:")]/../td').last.text,
      description: html.xpath('//td/font/b[contains(text(), "Description")]/../../../../../../../tr').last.text,
      mobile_number: html.xpath('//td[contains(text(), "Mobile Phone:")]/../td').last.children.first.text,
      expires_at: now + 1.weeks,
      created_at: now,
      updated_at: now
    }
  end

  def handle_removed_ad
    product = Product.find_by(url: url)
    # sync removed records from hamro bazaar
    product&.destroy
    raise CustomExceptions::ContentUnavailable, 'The Ad you are looking for is either expired or removed.'
  end
end
