# frozen_string_literal: true

require 'json'

class BaseController
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def not_found(msg = 'Resource not found')
    [404, { 'content-type' => 'application/json' }, [{ message: msg }.to_json]]
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
