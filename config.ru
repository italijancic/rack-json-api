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
  use Rack::Static, {
    root: '.',
    urls: ['/AUTHORS', '/openapi.yml'],
    headers_rules: [
      ['/AUTHORS', { 'Cache-Control' => 'public, max-age=86400' }],
      ['/openapi.yml', { 'Cache-Control' => 'no-store, no-cache, must-revalidate, max-age=0' }]
    ]
  }
  use BasicAuthMiddleware, ENV['BASIC_USER_NM'], ENV['BASIC_PASSWORD']
  run Application.new
end

run app
