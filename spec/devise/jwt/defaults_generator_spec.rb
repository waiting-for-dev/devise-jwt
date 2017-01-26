# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::DefaultsGenerator do
  subject(:defaults) { described_class.new }

  describe '#mappings' do
    it 'adds devise models with jwt' do
      expect(defaults.mappings).to eq(
        jwt_with_jti_matcher_user: JwtWithJtiMatcherUser,
        jwt_with_blacklist_user: JwtWithBlacklistUser,
        jwt_with_null_user: JwtWithNullUser
      )
    end
  end

  describe '#dispatch_requests' do
    # rubocop:disable RSpec/ExampleLength
    it 'adds create session requests for devise models with jwt' do
      expect(defaults.dispatch_requests).to eq(
        [
          ['POST', %r{^/jwt_with_jti_matcher_users/sign_in$}],
          ['POST', %r{^/jwt_with_blacklist_users/sign_in$}],
          ['POST', %r{^/jwt_with_null_users/sign_in$}]
        ]
      )
    end
  end

  describe '#revocation_requests' do
    it 'adds destroy session requests for devise models with jwt' do
      expect(defaults.revocation_requests).to eq(
        [
          ['DELETE', %r{^/jwt_with_jti_matcher_users/sign_out$}],
          ['DELETE', %r{^/jwt_with_blacklist_users/sign_out$}],
          ['DELETE', %r{^/jwt_with_null_users/sign_out$}]
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe '#revocation_strategies' do
    it 'adds strategies configured for each devise model with jwt' do
      expect(defaults.revocation_strategies).to eq(
        jwt_with_jti_matcher_user: JwtWithJtiMatcherUser,
        jwt_with_blacklist_user: Blacklist,
        jwt_with_null_user: Devise::JWT::RevocationStrategies::Null
      )
    end
  end

  context 'when rails version is less than 5' do
    # Fixture application is Rails 5. For now, instead of adding the burden of
    # another fixture app for Rails 4 we prefer mocking its behavior
    before do
      allow(Rails).to receive(:version).and_return('4.0')
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(
        ActionDispatch::Journey::Route
      ).to receive(:verb).and_return(/^GET$/)
      # rubocop:enable RSpec/AnyInstance
    end

    # https://github.com/rails/rails/pull/21849
    it 'correctly extract request methods returned as regexps' do
      first_extracted_method = defaults.dispatch_requests.first.first
      expect(first_extracted_method).to eq('GET')
    end
  end
end
