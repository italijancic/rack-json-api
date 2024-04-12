# frozen_string_literal: true

module TestDbHelper
  def seed_test_data
    (1..10).each do |i|
      dog = Dog.new(name: "Dog-#{i}")
      dog.save
    end
  end

  def reset_test_db
    Dog.all.each(&:delete)
  end
end
