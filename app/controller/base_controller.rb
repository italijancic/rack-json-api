# frozen_string_literal: true

require 'json'

class BaseController
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def index
    [200, { 'content-type' => 'text/plain' }, ['Rack JSON API v1.0.0']]
  end

  def not_found(msg = 'Resource not found')
    [404, { 'content-type' => 'application/json' }, [{ message: msg }.to_json]]
  end

  def internal_server_error
    [500, { 'content-type' => 'application/json' }, [{ message: 'Internal Server Error' }.to_json]]
  end

  private

  def json_response(body, status: 200)
    [status, { 'content-type' => 'application/json' }, [body.to_json]]
  end

  def params
    request.params
  end

  def body
    request.body
  end

  def resource
    request.params[:resource].to_s
  end

  def action
    request.params[:action].to_s
  end
end
