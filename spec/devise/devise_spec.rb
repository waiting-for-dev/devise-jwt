# frozen_string_literal: true

require 'spec_helper'

describe Devise do
  it "defines JWTAuth config settings in devise prepending with 'jwt'" do
    Warden::JWTAuth.config.to_h.keys.each do |setting|
      expect(described_class).to respond_to("jwt_#{setting}")
    end
  end

  it 'adds jwt_authenticatable module' do
    expect(described_class::ALL).to include(:jwt_authenticatable)
  end

  it 'associates jwt_authenticatable module with jwt strategy' do
    expect(described_class::STRATEGIES[:jwt_authenticatable]).to eq(:jwt)
  end

  it 'forwards to JWTAuth config settings set through Devise' do
    expiration_time = rand(100)

    described_class.jwt_expiration_time = expiration_time

    expect(described_class.jwt_expiration_time).to eq(expiration_time).and(
      eq(Warden::JWTAuth.config.expiration_time)
    )
  end
end
