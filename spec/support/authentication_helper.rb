# frozen_string_literal: true

require 'base64'
require 'dotenv'

module AuthenticationHelper
  def authenticated_request(method, path, options = {})
    credentials = "#{ENV['BASIC_USER_NM']}:#{ENV['BASIC_PASSWORD']}"
    auth_header = "Basic #{Base64.strict_encode64(credentials)}"
    headers = { 'HTTP_AUTHORIZATION' => auth_header }.merge(options[:headers] || {})
    send(method, path, options[:params], headers)
  end
end
