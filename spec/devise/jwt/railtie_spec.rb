# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::Railtie do
  let(:rails) { Rails }
  let(:rails_config) { Rails.configuration }

  it 'adds JWTAuth middleware' do
    expect(rails_config.middleware).to include(Warden::JWTAuth::Middleware)
  end
end
