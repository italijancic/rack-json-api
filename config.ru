# frozen_string_literal: true

require 'rack'
require 'rack/contrib'
require 'debug'
require_relative 'config/loader'

Loader.load(env: ENV['RACK_ENV']&.to_sym || :development)

app = Rack::Builder.new do
  use Rack::Reloader, 0
  use Rack::ETag
  use Rack::Deflater
  use Rack::ConditionalGet
  use ExcludeFromCache, ['/openapi.yml']
  use Rack::Static, {
    root: '.',
    urls: ['/AUTHORS', '/openapi.yml'],
    headers_rules: [
      [:all, { 'cache-control' => 'public, max-age=86400' }]
    ]
  }
  use BasicAuthMiddleware, ENV['BASIC_USER_NM'], ENV['BASIC_PASSWORD']
  run Application.new
end

run app
