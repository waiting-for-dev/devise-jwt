# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::Railtie do
  let(:rails) { Rails }
  let(:rails_config) { Rails.configuration }

  it 'adds JWTAuth middleware' do
    expect(rails_config.middleware).to include(Warden::JWTAuth::Middleware)
  end

  it 'configure mappings using defaults' do
    expect(Warden::JWTAuth.config.mappings).to include(
      jwt_with_jti_matcher_user: JwtWithJtiMatcherUser
    )
  end

  it 'does not override user defined mapping' do
    expect(Warden::JWTAuth.config.mappings).to include(
      no_jwt_user: NoJwtUser
    )
  end

  it 'configures dispatch_requests using defaults' do
    expect(Warden::JWTAuth.config.dispatch_requests).to include(
      ['POST', %r{^/jwt_with_jti_matcher_users/sign_in$}]
    )
  end

  it 'does not override user defined dispatch_requests' do
    expect(Warden::JWTAuth.config.dispatch_requests).to include(
      ['POST', %r{^/api/v1/no_jwt_user/sign_in$}]
    )
  end

  it 'configures revocation_requests using defaults' do
    expect(Warden::JWTAuth.config.revocation_requests).to include(
      ['DELETE', %r{^/jwt_with_jti_matcher_users/sign_out$}]
    )
  end

  it 'does not override user defined revocation_requests' do
    expect(Warden::JWTAuth.config.revocation_requests).to include(
      ['DELETE', %r{^/api/v1/no_jwt_user/sign_out$}]
    )
  end

  it 'configures revocation_strategies using defaults' do
    expect(Warden::JWTAuth.config.revocation_strategies).to include(
      jwt_with_jti_matcher_user: JwtWithJtiMatcherUser
    )
  end
end
