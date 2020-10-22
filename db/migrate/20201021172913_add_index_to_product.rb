# frozen_string_literal: true

class AddIndexToProduct < ActiveRecord::Migration[6.0]
  def change
    add_index :products, :url, unique: true
  end
end
