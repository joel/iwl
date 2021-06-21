# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

require "minitest/autorun"
require "minitest/focus"

require "rr"
RR.debug = true

require "minitest/reporters"
minitest_reporters = Minitest::Reporters::SpecReporter
Minitest::Reporters.use! minitest_reporters.new

require "database_cleaner"
require "database_cleaner/active_record"

DatabaseCleaner.strategy = :transaction

module ActiveSupport
  class TestCase
    extend MiniTest::Spec::DSL
    include FactoryBot::Syntax::Methods
    include DatabaseCleanerHook
  end
end
