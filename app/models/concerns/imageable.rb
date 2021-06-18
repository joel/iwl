# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern
  included do
    has_many :imageations, as: :imageable, dependent: :destroy
    has_many :images, through: :imageations, dependent: :destroy
  end
end
