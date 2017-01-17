# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::DefaultsGenerator do
  subject(:defaults) { described_class.new }

  describe '#mappings' do
    it 'adds devise models with jwt' do
      expect(defaults.mappings).to eq(
        jwt_user: JwtUser
      )
    end
  end

  describe '#dispatch_requests' do
    it 'adds create session requests for devise models with jwt' do
      expect(defaults.dispatch_requests).to eq(
        [['POST', %r{^/jwt_users/sign_in$}]]
      )
    end
  end

  describe '#revocation_requests' do
    it 'adds destroy session requests for devise models with jwt' do
      expect(defaults.revocation_requests).to eq(
        [['DELETE', %r{^/jwt_users/sign_out$}]]
      )
    end
  end
end
