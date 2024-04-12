# frozen_string_literal: true

class ExcludeFromCache
  def initialize(app, excluded_file_path)
    @app = app
    @excluded_file_paths = excluded_file_path
  end

  def call(env)
    request_path = env['PATH_INFO']

    if @excluded_file_paths.include?(request_path)
      # If the request matches the excluded file path, skip caching
      @app.call(env)
    else
      # Otherwise, let Rack::Static handle the request as usual
      # Otherwise, proceed with caching for other static files
      status, headers, response = @app.call(env)

      # Optionally modify caching headers here for non-excluded paths
      headers['Cache-Control'] = 'public, max-age=86400' # Example caching header

      [status, headers, response]
    end
  end
end
