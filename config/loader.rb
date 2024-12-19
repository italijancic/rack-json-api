# frozen_string_literal: true

require 'debug'
require 'dotenv'
require 'logger'
require 'rack'
require 'rack/contrib'
require 'zeitwerk'

class Loader
  attr_reader :loader, :env

  TEST_DIRECTORIES = %w[spec/].freeze

  def initialize(**kwargs)
    @loader = Zeitwerk::Loader.new
    @env = kwargs[:env]
  end

  def load
    load_project_paths
    loader.setup
    load_env_variables
  end

  def self.load(**kwargs)
    new(**kwargs).load
  end

  private

  def load_project_paths
    paths.each { |path| loader.push_dir(File.expand_path(path)) }
  end

  def paths
    @paths ||= begin
      paths = Dir.glob('**/*/')

      unless env == :test
        paths.reject! do |path|
          TEST_DIRECTORIES.any? { |test_dir| path.include?(test_dir) }
        end
      end

      paths
    end
  end

  def load_env_variables
    Dotenv.load(".env.#{env}")
  end
end
