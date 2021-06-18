# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    name { FFaker::Movie.title }
  end
end
