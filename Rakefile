# frozen_string_literal: true

require 'rake'
require_relative 'config/loader'
Loader.load(env: ENV['RACK_ENV']&.to_sym || :development)

# Define a Rake task to seed the database
namespace :db do
  task :seed do
    (1..10).each do |i|
      Product.create(name: "Product-#{i}")
    end
    puts 'Database seeded successfully!'
  end

  task :delete do
    Product.all.each(&:delete)
    puts 'Database deleted successfully!'
  end
end
