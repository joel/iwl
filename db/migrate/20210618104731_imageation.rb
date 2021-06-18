# frozen_string_literal: true

class Imageation < ActiveRecord::Migration[5.2]
  def change
    create_table :imageations do |t|
      t.belongs_to :image, index: true
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
