# frozen_string_literal: true

require 'spec_helper'

APP = Rack::Builder.parse_file('config.ru').first

describe Application do
  include AuthenticationHelper

  def app
    APP
  end

  context "when doing a GET '/jsondogs'" do
    let(:response) { authenticated_request :get, '/jsondogs' }

    context 'when request is authenticated' do
      it 'returns a 200 status code and a hello world in the body' do
        expect(response.status).to eq(200)
        expect(response.body).to eq ObjectSerializer.serialize_each(Dog.all).to_json
      end
    end

    context 'when request is not authenticated' do
      let(:response) { get '/jsondogs' }

      it 'returns a 401' do
        expect(response.status).to eq 401
      end
    end
  end
end
