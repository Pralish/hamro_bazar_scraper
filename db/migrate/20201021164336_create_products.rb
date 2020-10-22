# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :url
      t.string :title
      t.datetime :expires_at
      t.string :description
      t.string :mobile_number
      t.string :price

      t.timestamps
    end
  end
end
