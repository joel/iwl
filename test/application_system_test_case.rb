# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # http://chromedriver.chromium.org/capabilities

  if ENV["CHROME_HEADLESS"]
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: { url: ENV.fetch("HUB_URL") }
    Capybara.always_include_port = true
  else
    driven_by :selenium, using: :chrome do |driver_options|
      driver_options.add_argument("--no-sandbox")
      driver_options.add_argument("--disable-dev-shm-usage")
      driver_options.add_argument("--disable-gpu")
      driver_options.add_argument("--window-size=1400,1400")
    end
  end
end
