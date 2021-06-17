# frozen_string_literal: true

module DatabaseCleanerHook
  extend ActiveSupport::Concern

  included do
    before(:all) do
      DatabaseCleaner.start
    end

    after(:all) do
      DatabaseCleaner.clean
    end
  end
end
