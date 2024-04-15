# frozen_string_literal: true

class Product < BaseModel
  attr_accessor :id, :name

  def initialize(id: nil, name: nil)
    @id = id
    @name = name
  end
end
