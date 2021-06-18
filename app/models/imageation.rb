# frozen_string_literal: true

class Imageation < ApplicationRecord
  belongs_to :image
  belongs_to :imageable, polymorphic: true
end
