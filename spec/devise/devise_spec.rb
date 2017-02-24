# frozen_string_literal: true

require 'spec_helper'

describe Devise do
  describe '::jwt' do
    it 'yields to Devise::JWT.config' do
      described_class.jwt { |jwt| jwt.expiration_time = 900 }

      expect(Devise::JWT.config.expiration_time).to eq(900)
    end
  end

  it 'adds jwt_authenticatable module' do
    expect(described_class::ALL).to include(:jwt_authenticatable)
  end

  it 'associates jwt_authenticatable module with jwt strategy' do
    expect(described_class::STRATEGIES[:jwt_authenticatable]).to eq(:jwt)
  end
end
