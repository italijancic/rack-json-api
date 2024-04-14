# frozen_string_literal: true

module TestDbHelper
  def seed_test_data
    (1..10).each do |i|
      product = Product.new(name: "Dog-#{i}")
      product.save
    end
  end

  def reset_test_db
    Product.all.each(&:delete)
  end
end
