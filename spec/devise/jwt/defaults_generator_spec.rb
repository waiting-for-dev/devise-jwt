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
    it 'adds create session requests for devise models with jwt' do
      expect(defaults[:dispatch_requests]).to include(
        ['POST', %r{^/jwt_with_jti_matcher_users/sign_in$}],
        ['POST', %r{^/jwt_with_blacklist_users/sign_in$}]
      )
    end

    it 'respect route scopes for create session requests' do
      expect(defaults[:dispatch_requests]).to include(
        ['POST', %r{^/a/scope/jwt_with_null_users/sign_in$}]
      )
    end

    it 'does not add create session requests for devise models without jwt' do
      expect(defaults[:dispatch_requests]).not_to include(
        ['POST', %r{^/no_jwt_users/sign_in$}]
      )
    end

    it 'adds registration requests for devise models with jwt' do
      expect(defaults[:dispatch_requests]).to include(
        ['POST', %r{^/jwt_with_jti_matcher_users$}],
        ['POST', %r{^/jwt_with_blacklist_users$}]
      )
    end

    it 'respect route scopes for registration requests' do
      expect(defaults[:dispatch_requests]).to include(
        ['POST', %r{^/a/scope/jwt_with_null_users$}]
      )
    end

    it 'does not add registration requests for devise models without jwt' do
      expect(defaults[:dispatch_requests]).not_to include(
        ['POST', %r{^/no_jwt_users$}]
      )
    end
  end

  describe 'revocation_requests' do
    it 'adds destroy session requests for devise models with jwt' do
      expect(defaults[:revocation_requests]).to include(
        ['DELETE', %r{^/jwt_with_jti_matcher_users/sign_out$}],
        ['DELETE', %r{^/jwt_with_blacklist_users/sign_out$}]
      )
    end

    it 'respect route scopes for destroy session requests' do
      expect(defaults[:revocation_requests]).to include(
        ['POST', %r{^/a/scope/jwt_with_null_users/sign_out$}]
      )
    end

    it 'does not add destroy session requests for devise models without jwt' do
      expect(defaults[:revocation_requests]).not_to include(
        ['POST', %r{^/no_jwt_users/sign_out$}]
      )
    end
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
