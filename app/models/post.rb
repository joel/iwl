# frozen_string_literal: true

class Post < ApplicationRecord
  has_one_attached :header_picture
  accepts_nested_attributes_for :header_picture_attachment, allow_destroy: true
end
