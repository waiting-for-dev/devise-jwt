# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::RevocationStrategies::JTIMatcher do
  subject(:strategy) { JwtWithJtiMatcherUser }

  include_context 'fixtures'

  let(:model) { JwtWithJtiMatcherUser }

  let(:user) { jwt_with_jti_matcher_user }

  describe 'Callbacks' do
    context 'with before create' do
      it 'initializes jti' do
        expect(user.jti).not_to be_nil
      end
    end
  end

  describe '#jwt_revoked?(payload, user)' do
    let(:payload) { { 'jti' => jti } }

    context 'when jti in payload matches user jti column' do
      let(:jti) { user.jti }

      it 'returns false' do
        expect(strategy.jwt_revoked?(payload, user)).to eq(false)
      end
    end

    context 'when jti in payload does not match user jti column' do
      let(:jti) { '123' }

      it 'returns true' do
        expect(strategy.jwt_revoked?(payload, user)).to eq(true)
      end
    end
  end

  describe '#revoke_jwt(payload, user)' do
    it 'changes user jti column' do
      expect { strategy.revoke_jwt('whatever', user) }.to(change(user, :jti))
    end
  end

  describe '#jwt_payload' do
    it 'includes jti column in jti claim' do
      expect(user.jwt_payload['jti']).to eq(user.jti)
    end
  end
end
