# frozen_string_literal: true

class ProductsController < BaseController
  # GET /products
  #
  def index
    @products = Product.all
    if @products.empty?
      not_found
    else
      json_response(ObjectSerializer.serialize_each(@products))
    end
  end

  # GET /products/:id
  #
  def show
    @product = Product.find(id)
    if @product.nil?
      not_found
    else
      json_response(ObjectSerializer.serialize(@product))
    end
  end

  # POST /products
  #
  def create
    data = JSON.parse(request.body.read)
    product = Product.new(name: data['name'])
    product.save
    json_response({ message: "Product #{data['name']} was created" })
  end

  # DELETE /products/:id
  def delete
    product = Product.find(id)
    if product.nil?
      json_response({ message: "Product #{id} not found" }, status: 404)
    else
      Product.delete
      json_response({ message: "Product #{id} was delete" })
    end
  end

  private

  def id
    params[:id].to_i
  end
end
