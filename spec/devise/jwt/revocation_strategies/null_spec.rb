# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::RevocationStrategies::Null do
  subject(:strategy) { described_class }

  describe '#jwt_revoked?(payload, user)' do
    it 'returns false' do
      expect(strategy.jwt_revoked?(:whatever, :whatever)).to eq(false)
    end
  end

  describe '#revoke_jwt(payload, user)' do
    it('does nothing') {}
  end
end
