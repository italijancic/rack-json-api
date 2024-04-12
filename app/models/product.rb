# frozen_string_literal: true

class Product < BaseModel
  attr_accessor :id, :name

  def initialize(id: nil, name: nil, price: nil)
    @id = id
    @name = name
    @price = price
  end
end
