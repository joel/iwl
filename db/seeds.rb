# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if defined?(FactoryBot)
  15.times.each do
    FactoryBot.create(:post)
    print "." # rubocop:disable Rails/Output
  end
else
  puts("FactoryBot undefined") # rubocop:disable Rails/Output
end
