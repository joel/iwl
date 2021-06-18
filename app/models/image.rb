# frozen_string_literal: true

class Image < ApplicationRecord
  has_many :imageations, dependent: :destroy
end
