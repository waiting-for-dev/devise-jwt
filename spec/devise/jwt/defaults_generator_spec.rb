# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::DefaultsGenerator do
  subject(:defaults) { described_class.call }

  describe 'mappings' do
    # rubocop:disable RSpec/ExampleLength
    it 'adds devise models with jwt as strings' do
      expect(defaults[:mappings]).to eq(
        jwt_with_jti_matcher_user: 'JwtWithJtiMatcherUser',
        jwt_with_denylist_user: 'JwtWithDenylistUser',
        jwt_with_allowlist_user: 'JwtWithAllowlistUser',
        jwt_with_null_user: 'JwtWithNullUser'
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'dispatch_requests' do
    it 'adds create session requests for devise models with jwt' do
      expect(defaults[:dispatch_requests]).to include(
        ['POST', %r{^/jwt_with_jti_matcher_users/sign_in$}]
      )
    end

    # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    it 'respects configured format segment for create session requests' do
      expect(defaults[:dispatch_requests]).to include(
        ['POST', %r{^/jwt_with_denylist_users/sign_in.json$}],
        ['POST', %r{^/jwt_with_denylist_users/sign_in.xml$}]
      )
      expect(defaults[:dispatch_requests]).not_to include(
        ['POST', %r{^/jwt_with_denylist_users/sign_in$}]
      )
    end
    # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations

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
        ['POST', %r{^/jwt_with_jti_matcher_users$}]
      )
    end

    # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    it 'respects configured format segment for registration requests' do
      expect(defaults[:dispatch_requests]).to include(
        ['POST', %r{^/jwt_with_denylist_users.json$}],
        ['POST', %r{^/jwt_with_denylist_users.xml$}]
      )
      expect(defaults[:dispatch_requests]).not_to include(
        ['POST', %r{^/jwt_with_denylist_users$}]
      )
    end
    # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations

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
        ['DELETE', %r{^/jwt_with_jti_matcher_users/sign_out$}]
      )
    end

    # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    it 'respects configured format segment for destroy session requests' do
      expect(defaults[:revocation_requests]).to include(
        ['POST', %r{^/jwt_with_denylist_users/sign_out.json$}],
        ['POST', %r{^/jwt_with_denylist_users/sign_out.xml$}]
      )
      expect(defaults[:revocation_requests]).not_to include(
        ['POST', %r{^/jwt_with_denylist_users/sign_out$}]
      )
    end
    # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations

    it 'respect sign_out_via configuration for destroy session requests' do
      expect(defaults[:revocation_requests]).to include(
        ['POST',   %r{^/jwt_with_denylist_users/sign_out.json$}],
        ['GET',    %r{^/jwt_with_allowlist_users/sign_out$}],
        ['DELETE', %r{^/jwt_with_allowlist_users/sign_out$}]
      )
    end

    it 'respect route scopes for destroy session requests' do
      expect(defaults[:revocation_requests]).to include(
        ['DELETE', %r{^/a/scope/jwt_with_null_users/sign_out$}]
      )
    end

    it 'does not add destroy session requests for devise models without jwt' do
      expect(defaults[:revocation_requests]).not_to include(
        ['DELETE', %r{^/no_jwt_users/sign_out$}]
      )
    end
  end

  describe 'revocation_strategies' do
    # rubocop:disable RSpec/ExampleLength
    it 'adds strategies configured for each devise model with jwt' do
      expect(defaults[:revocation_strategies]).to eq(
        jwt_with_jti_matcher_user: 'JwtWithJtiMatcherUser',
        jwt_with_denylist_user: 'JWTDenylist',
        jwt_with_allowlist_user: 'JwtWithAllowlistUser',
        jwt_with_null_user: 'Devise::JWT::RevocationStrategies::Null'
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
