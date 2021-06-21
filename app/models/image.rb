# frozen_string_literal: true

class Image < ApplicationRecord
  has_many :imageations, dependent: :destroy

  has_one_attached :attachment
end
