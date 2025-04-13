# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::RevocationStrategies::Null do
  subject(:strategy) { described_class }

  describe '#jwt_revoked?(payload, user)' do
    it 'returns false' do
      expect(strategy.jwt_revoked?(:whatever, :whatever)).to be(false)
    end
  end
end
