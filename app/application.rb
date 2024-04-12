# frozen_string_literal: true

class Application
  def call(env)
    handle_request(env)
  end

  private

  def handle_request(env)
    Router.new(Rack::Request.new(env)).route
  end
end
