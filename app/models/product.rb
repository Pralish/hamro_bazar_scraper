# frozen_string_literal: true

class Product < ApplicationRecord
  validates :url, presence: true, uniqueness: true
end
