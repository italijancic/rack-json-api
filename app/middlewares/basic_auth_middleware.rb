# frozen_string_literal: true

class BasicAuthMiddleware
  def initialize(app, username, password)
    @app = app
    @username = username
    @password = password
  end

  def call(env)
    auth = Rack::Auth::Basic::Request.new(env)

    if auth.provided? && auth.basic? && authenticate(*auth.credentials)
      @app.call(env)
    else
      unauthorized_response
    end
  end

  private

  def authenticate(username, password)
    username == ENV['BASIC_USER_NM'] && password == ENV['BASIC_PASSWORD']
  end

  def unauthorized_response
    headers = {
      'content-type' => 'text/plain',
      'WWW-Authenticate' => 'Basic realm="Restricted Area"'
    }
    body = ['Unauthorized']
    [401, headers, body]
  end
end
