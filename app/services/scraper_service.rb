# frozen_string_literal: true

require 'open-uri'

class ScraperService
  def initialize(url)
    @url = url
    @now = Time.now
  end

  def call
    scrape
  end

  private

  attr_reader :url, :now

  def scrape
    content = open(@url)
    html = Nokogiri::HTML(content)
    details = {
      url: @url,
      title: html.css('.title').text,
      price: html.xpath('//td[contains(text(), "Price:")]/../td').last.text,
      description: html.xpath('//td/font/b[contains(text(), "Description")]/../../../../../../../tr').last.text,
      mobile_number: html.xpath('//td[contains(text(), "Mobile Phone:")]/../td').last.children.first.text,
      created_at: now,
      expires_at: now + 7.days,
      updated_at: now
    }
  end
end
