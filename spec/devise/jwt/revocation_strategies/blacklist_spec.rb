# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::RevocationStrategies::Blacklist do
  subject(:strategy) { Blacklist }

  let(:payload) { { 'jti' => '123' } }

  describe '#jwt_revoked?(payload, user)' do
    context 'when payload jti is in the blacklist' do
      it 'returns true' do
        strategy.create(jti: '123')

        expect(strategy.jwt_revoked?(payload, :whatever)).to eq(true)
      end
    end

    context 'when payload jti is not in the blacklist' do
      it 'returns true' do
        expect(strategy.jwt_revoked?(payload, :whatever)).to eq(false)
      end
    end
  end

  describe '#revoke_jwt(payload, user)' do
    it 'adds payload jti to the blacklist' do
      strategy.revoke_jwt(payload, :whatever)

      expect(strategy.find_by(jti: '123')).not_to be_nil
    end
  end
end
