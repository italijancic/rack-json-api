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
    Product.create_async({ name: data['name'] }, delay: 5)
    json_response({ message: "Product #{data['name']} will be created after 5 seg" })
  end

  # DELETE /products/:id
  def delete
    product = Product.find(id)
    if product.nil?
      not_found
    else
      product.delete
      json_response({ message: "Product #{id} was delete" })
    end
  end

  private

  def id
    params[:id].to_i
  end
end
