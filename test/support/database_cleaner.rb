# require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

class Minitest::Spec
  around do |tests|
    DatabaseCleaner.cleaning(&tests)
  end
end