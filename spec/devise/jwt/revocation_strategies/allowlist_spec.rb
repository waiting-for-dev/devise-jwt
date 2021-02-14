# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::RevocationStrategies::Allowlist do
  subject(:strategy) { JwtWithAllowlistUser }

  include_context 'fixtures'

  let(:model) { JwtWithAllowlistUser }

  let(:user) { jwt_with_allowlist_user }

  let(:payload) do
    { 'jti' => '123', 'aud' => 'client1', 'exp' => Time.at(1_501_717_440) }
  end

  describe '#jwt_revoked?(payload, user)' do
    context 'when jti and aud in payload exist on jwt_allowlist' do
      before { user.allowlisted_jwts.create(payload) }

      it 'returns false' do
        expect(strategy.jwt_revoked?(payload, user)).to eq(false)
      end
    end

    context 'when jti and aud payload does not exist on jwt_allowlist' do
      it 'returns true' do
        expect(strategy.jwt_revoked?(payload, user)).to eq(true)
      end
    end
  end

  describe '#revoke_jwt(payload, user)' do
    before { user.allowlisted_jwts.create(payload) }

    it 'deletes matching jwt_allowlist record' do
      expect { strategy.revoke_jwt(payload, user) }
        .to(change { user.allowlisted_jwts.count }.by(-1))
    end

    it 'does not crash when token has already been revoked' do
      strategy.revoke_jwt(payload, user)

      strategy.revoke_jwt(payload, user)
    end
  end

  describe '#on_jwt_dispatch(token, payload)' do
    it 'creates allowlisted_jwt record from the payload' do
      jwt_with_allowlist_user.on_jwt_dispatch(:token, payload)

      expect(
        jwt_with_allowlist_user.allowlisted_jwts.exists?(payload)
      ).to eq(true)
    end
  end
end
