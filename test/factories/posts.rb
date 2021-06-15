# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    name { FFaker::Lorem.sentence }
  end
end
