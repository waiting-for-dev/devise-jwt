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

  it 'configures dispatch_requests using defaults' do
    expect(Warden::JWTAuth.config.dispatch_requests).to include(
      ['POST', %r{^/jwt_with_jti_matcher_users/sign_in$}]
    )
  end

  it 'does not override user defined dispatch_requests' do
    expect(Warden::JWTAuth.config.dispatch_requests).to include(
      ['GET', %r{^/foo_path$}]
    )
  end

  it 'configures revocation_requests using defaults' do
    expect(Warden::JWTAuth.config.revocation_requests).to include(
      ['DELETE', %r{^/jwt_with_jti_matcher_users/sign_out$}]
    )
  end

  it 'does not override user defined revocation' do
    expect(Warden::JWTAuth.config.revocation_requests).to include(
      ['GET', %r{^/bar_path$}]
    )
  end

  it 'configures revocation_strategies using defaults' do
    expect(Warden::JWTAuth.config.revocation_strategies).to include(
      jwt_with_jti_matcher_user: JwtWithJtiMatcherUser
    )
  end

  it 'configures algorithm using defaults' do
    expect(Warden::JWTAuth.config.algorithm).to eq('HS256')
  end

  it 'configures decoding_secret using defaults' do
    expect(Warden::JWTAuth.config.decoding_secret).to eq(
      Warden::JWTAuth.config.secret
    )
  end

  context 'when asymmetric algorithm is user configured' do
    let(:rsa_secret) { OpenSSL::PKey::RSA.generate 2048 }
    let(:decoding_secret) { rsa_secret.public_key }

    before do
      Rails.configuration.devise.jwt do |jwt|
        jwt.algorithm = 'RS256'
        jwt.secret = rsa_secret
        jwt.decoding_secret = decoding_secret
      end
    end

    it 'does not override user defined algorithm' do
      expect(Warden::JWTAuth.config.algorithm).to eq('RS256')
    end

    it 'does not override user defined secret' do
      expect(Warden::JWTAuth.config.secret).to eq(rsa_secret)
    end

    it 'does not override user defined decoding_secret' do
      expect(Warden::JWTAuth.config.decoding_secret).to eq(decoding_secret)
    end
  end
end
