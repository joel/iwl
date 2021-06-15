# frozen_string_literal: true

# require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

class Minitest::Spec # rubocop:disable Style/ClassAndModuleChildren
  around do |tests|
    DatabaseCleaner.cleaning(&tests)
  end
end
