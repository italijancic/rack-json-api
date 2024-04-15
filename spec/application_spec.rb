# frozen_string_literal: true

require 'spec_helper'

APP = Rack::Builder.parse_file('config.ru').first

describe Application do
  include AuthenticationHelper

  def app
    APP
  end

  context 'when doing a GET for statics files' do
    context 'when request /openapi.yml' do
      let(:response) { authenticated_request :get, '/openapi.yml' }

      it 'returns a 200 status code and a list of products' do
        expect(response).to be_ok
      end
    end

    context 'when request is /AUTHORS' do
      let(:response) { authenticated_request :get, '/AUTHORS' }

      it 'returns a 200 status code and a list of products' do
        expect(response).to be_ok
      end
    end
  end

  context "when doing a GET '/products'" do
    let(:response) { authenticated_request :get, '/products' }

    context 'when request is authenticated' do
      it 'returns a 200 status code and a list of products' do
        expect(response.status).to eq(200)
        expect(response.body).to eq ObjectSerializer.serialize_each(Product.all).to_json
      end
    end

    context 'when request is not authenticated' do
      let(:response) { get '/products' }

      it 'returns a 401' do
        expect(response.status).to eq 401
      end
    end
  end

  context "when doing a GET '/products/1'" do
    let(:response) { authenticated_request :get, '/products/1' }

    context 'when request is authenticated' do
      it 'returns a 200 status code and a first product' do
        expect(response.status).to eq(200)
        expect(response.body).to eq ObjectSerializer.serialize(Product.first).to_json
      end
    end

    context 'when request is not authenticated' do
      let(:response) { get '/products/1' }

      it 'returns a 401' do
        expect(response.status).to eq 401
      end
    end
  end

  context "when doing a GET '/products/1'" do
    let(:response) { authenticated_request :delete, '/products/10' }

    context 'when request is authenticated' do
      it 'returns a 200 status code' do
        expect(response.status).to eq(200)
        expect(Product.all.length).to eq(9)
      end
    end

    context 'when request is not authenticated' do
      let(:response) { get '/products/10' }

      it 'returns a 401' do
        expect(response.status).to eq 401
      end
    end
  end
end
