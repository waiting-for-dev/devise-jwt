# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path(
  '../../../fixtures/rails_app/config/environment', __FILE__
)

describe Devise::JWT::Railtie do
  let(:rails) { Rails }
  let(:rails_config) { Rails.configuration }

  it 'adds middleware Warden::JWTAuth::Middleware' do
    expect(rails_config.middleware).to include(Warden::JWTAuth::Middleware)
  end
end
