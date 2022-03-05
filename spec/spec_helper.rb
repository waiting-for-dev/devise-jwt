# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'devise/jwt'
require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
require 'rails/test_unit/railtie'

require 'rspec/rails'
require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path(
  'fixtures/rails_app/config/environment', __dir__
)

SPEC_ROOT = Pathname(__FILE__).dirname
Dir[SPEC_ROOT.join('support/**/*.rb')].sort.each do |file|
  require file
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
