# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # http://chromedriver.chromium.org/capabilities

  # parallelize(workers: 1) parallelize_me!

  if ENV["CHROME_HEADLESS"]


    # Capybara.app_host = "0.0.0.0"

    # Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    # puts "!!!!!!!!!!!! = > #{IPSocket.getaddress(Socket.gethostname)}"

    Capybara.server_host = "0.0.0.0"
    Capybara.server_port = 3000

    # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400],
    #                     options: {
    #                       browser: :remote,
    #                       url: ENV['HUB_URL'],
    #                     }

    Capybara.register_driver :chrome_headless do |app|
      chrome_capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { 'args': %w[no-sandbox headless disable-gpu window-size=1400,1400] })
      Capybara::Selenium::Driver.new(app,
                                   browser: :remote,
                                   url: ENV['HUB_URL'],
                                   desired_capabilities: chrome_capabilities)
    end
    driven_by :chrome_headless

    # Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:3000"
    # Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    # Capybara.server_port = 3000

  else
    # driver = ENV["CHROME_HEADLESS"] ? :headless_chrome : :chrome
    driver = :chrome

    driven_by :selenium, using: driver do |driver_options|
      driver_options.add_argument("--no-sandbox")
      driver_options.add_argument("--disable-dev-shm-usage")
      driver_options.add_argument("--disable-gpu")
      driver_options.add_argument("--window-size=1400,1400")
    end
  end
end
