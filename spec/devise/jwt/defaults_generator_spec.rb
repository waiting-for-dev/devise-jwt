# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::DefaultsGenerator do
  subject(:defaults) { described_class.call }

  describe 'mappings' do
    it 'adds devise models with jwt' do
      expect(defaults[:mappings]).to eq(
        jwt_with_jti_matcher_user: JwtWithJtiMatcherUser,
        jwt_with_blacklist_user: JwtWithBlacklistUser,
        jwt_with_null_user: JwtWithNullUser
      )
    end
  end

  describe 'dispatch_requests' do
    # rubocop:disable RSpec/ExampleLength
    it 'adds create session requests for devise models with jwt' do
      expect(defaults[:dispatch_requests]).to eq(
        [
          ['POST', %r{^/jwt_with_jti_matcher_users/sign_in$}],
          ['POST', %r{^/jwt_with_blacklist_users/sign_in$}],
          ['POST', %r{^/jwt_with_null_users/sign_in$}]
        ]
      )
    end
  end

  describe 'revocation_requests' do
    it 'adds destroy session requests for devise models with jwt' do
      expect(defaults[:revocation_requests]).to eq(
        [
          ['DELETE', %r{^/jwt_with_jti_matcher_users/sign_out$}],
          ['DELETE', %r{^/jwt_with_blacklist_users/sign_out$}],
          ['POST', %r{^/jwt_with_null_users/sign_out$}]
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'revocation_strategies' do
    it 'adds strategies configured for each devise model with jwt' do
      expect(defaults[:revocation_strategies]).to eq(
        jwt_with_jti_matcher_user: JwtWithJtiMatcherUser,
        jwt_with_blacklist_user: Blacklist,
        jwt_with_null_user: Devise::JWT::RevocationStrategies::Null
      )
    end
  end
end
