# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::Models::JWTAuthenticatable do
  subject(:user_class) { JwtUser }

  describe '#find_for_jwt_authentication(sub)' do
    it 'finds record which has given `sub` as `id`' do
      record = user_class.create(email: 'dummy@email.com', password: 'password')

      id = record.id

      expect(user_class.find_for_jwt_authentication(id)).to eq(record)
    end
  end

  describe '#jwt_subject' do
    it 'returns id' do
      record = user_class.create(email: 'dummy@email.com', password: 'password')

      expect(record.jwt_subject).to eq(record.id)
    end
  end
end
