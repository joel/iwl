# frozen_string_literal: true

json.extract! image, :id, :name, :created_at, :updated_at
json.url image_url(image, format: :json)
