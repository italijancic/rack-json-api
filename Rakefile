# frozen_string_literal: true

require 'rake'
require_relative 'config/loader'
Loader.load(env: ENV['RACK_ENV']&.to_sym || :development)

import './app/tasks/db.rake'
