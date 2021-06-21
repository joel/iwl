# frozen_string_literal: true

class Image < ApplicationRecord
  has_many :imageations, dependent: :destroy

  has_many_attached :attachments
end
