# frozen_string_literal: true

class ConditionalDeflater
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # Check if client supports gzip compression
    if include_gzip?(request)
      # Use Rack::Deflater middleware if client supports gzip compression
      Rack::Deflater.new(@app).call(env)
    else
      # Otherwise, pass the request through without compression
      @app.call(env)
    end
  end

  private

  def include_gzip?(request)
    request.accept_encoding.any? { |sub_array| sub_array.include?('gzip') }
  end
end
