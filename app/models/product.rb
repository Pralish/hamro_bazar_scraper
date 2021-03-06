# frozen_string_literal: true

class Product < ApplicationRecord
  validates :url, presence: true, uniqueness: true

  def expired?
    expires_at > Time.zone.now
  end
end
