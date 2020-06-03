# frozen_string_literal: true

require 'spec_helper'
require 'devise/jwt/test_helpers'

describe Devise::JWT::TestHelpers do
  include_context 'fixtures'

  let(:headers) { { 'foo' => 'bar', 'JWT_AUD' => 'client' } }
  let(:user) { jwt_with_jti_matcher_user }

  # :reek:UtilityFunction
  def payload_from_headers(headers)
    _method, token = headers['Authorization'].split
    Warden::JWTAuth::TokenDecoder.new.call(token)
  end

  describe '::auth_headers(headers, user, scope:, aud:)' do
    it 'adds a valid token in the Authorization header' do
      auth_headers = described_class.auth_headers(headers, user)
      payload = payload_from_headers(auth_headers)

      expect(payload['sub']).to eq(user.id.to_s)
    end

    it 'preserves present headers' do
      auth_headers = described_class.auth_headers(headers, user)

      expect(auth_headers['foo']).to eq('bar')
    end

    it 'detects user scope' do
      auth_headers = described_class.auth_headers(headers, user)
      payload = payload_from_headers(auth_headers)

      expect(payload['scp']).to eq('jwt_with_jti_matcher_user')
    end

    it 'can manually specify scope' do
      auth_headers = described_class.auth_headers(headers, user, scope: :foo)
      payload = payload_from_headers(auth_headers)

      expect(payload['scp']).to eq('foo')
    end

    it 'detects aud header' do
      auth_headers = described_class.auth_headers(headers, user)
      payload = payload_from_headers(auth_headers)

      expect(payload['aud']).to eq('client')
    end

    it 'can manually specify aud claim' do
      auth_headers = described_class.auth_headers(headers, user, aud: 'foo')
      payload = payload_from_headers(auth_headers)

      expect(payload['aud']).to eq('foo')
    end

    it 'calls on_jwt_dispatch method on the user model' do
      user = jwt_with_allowlist_user
      auth_headers = described_class.auth_headers(headers, user)
      payload = payload_from_headers(auth_headers)

      expect(user.allowlisted_jwts.first.jti).to eq(payload['jti'])
    end
  end
end
