# frozen_string_literal: true

module TestDbHelper
  def seed_test_data
    (1..10).each do |i|
      product = Product.create(name: "Product-#{i}")
    end
  end

  def reset_test_db
    Product.all.each(&:delete)
  end
end
