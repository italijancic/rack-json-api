# frozen_string_literal: true

# Define a Rake task to seed the database
namespace :db do
  desc 'Seed database for development'
  task :seed do
    (1..10).each do |i|
      Product.create(name: "Product-#{i}")
    end
    puts 'Database seeded successfully!'
  end

  desc 'Delete development database data'
  task :delete do
    Product.all.each(&:delete)
    puts 'Database deleted successfully!'
  end
end
