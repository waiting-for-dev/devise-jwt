# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'devise/jwt'
require 'rails/all'
require 'rspec/rails'
require 'pry-byebug'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path(
  '../fixtures/rails_app/config/environment', __FILE__
)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
