# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'devise/jwt'
require 'rails/all'
require 'rspec/rails'
require 'pry-byebug'
require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path(
  '../fixtures/rails_app/config/environment', __FILE__
)

SPEC_ROOT = Pathname(__FILE__).dirname
Dir[SPEC_ROOT.join('support/**/*.rb')].each do |file|
  require file
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
