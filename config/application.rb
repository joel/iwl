# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImagesFurry
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    if ENV["RAILS_LOG_TO_STDOUT"].present?
      STDOUT.sync = true
      config.rails_semantic_logger.add_file_appender = false
      config.semantic_logger.add_appender(io: STDOUT, level: config.log_level, formatter: config.rails_semantic_logger.format)
    end

    if ENV["LOG_LEVEL"].present?
      config.log_level = ENV["LOG_LEVEL"].downcase.strip.to_sym
    end

    if ENV["LOG_APPENDER"].present?
      config.rails_semantic_logger.started    = true
      config.rails_semantic_logger.processing = true
      config.rails_semantic_logger.rendered   = true
    end
  end
end
