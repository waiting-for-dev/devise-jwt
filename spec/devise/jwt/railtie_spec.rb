# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::Railtie do
  let(:rails) { Rails }
  let(:rails_config) { Rails.configuration }

  it 'adds JWTAuth middleware' do
    expect(rails_config.middleware).to include(Warden::JWTAuth::Middleware)
  end

  it 'configures as JWTAuth mappings devise models configured with jwt' do
    expect(Warden::JWTAuth.config.mappings).to eq(
      jwt_user: JwtUser
    )
  end

  it 'configures as dispatch_requests sign_in for models with jwt' do
    expect(Warden::JWTAuth.config.dispatch_requests).to eq(
      [['POST', %r{^/jwt_users/sign_in$}]]
    )
  end

  it 'configures as revocation_requests sign_out for models with jwt' do
    expect(Warden::JWTAuth.config.revocation_requests).to eq(
      [['DELETE', %r{^/jwt_users/sign_out$}]]
    )
  end
end
