# frozen_string_literal: true

require 'spec_helper'

describe 'Authorization', type: :request do
  include_context 'feature'
  include_context 'fixtures'

  context 'JWT user with JTI matcher revocation' do
    let(:user) { jwt_with_jti_matcher_user }
    let(:user_params) do
      {
        jwt_with_jti_matcher_user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'authorizes requests with a valid token' do
      auth = sign_in(jwt_with_jti_matcher_user_session_path, user_params)

      get_with_auth('/jwt_with_jti_matcher_user_auth_action', auth)

      expect(response.status).to eq(200)
    end

    it 'unauthorizes requests with an invalid token' do
      auth = 'Bearer 123'

      get_with_auth('/jwt_with_jti_matcher_user_auth_action', auth)

      expect(response.status).to eq(401)
    end
  end

  context 'JWT user with Blacklist revocation' do
    let(:user) { jwt_with_blacklist_user }
    let(:user_params) do
      {
        jwt_with_blacklist_user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'authorizes requests with a valid token' do
      auth = sign_in(jwt_with_blacklist_user_session_path, user_params)

      get_with_auth('/jwt_with_blacklist_user_auth_action', auth)

      expect(response.status).to eq(200)
    end

    it 'unauthorizes requests with an invalid token' do
      auth = 'Bearer 123'

      get_with_auth('/jwt_with_blacklist_user_auth_action', auth)

      expect(response.status).to eq(401)
    end
  end

  context 'JWT user with Null revocation' do
    let(:user) { jwt_with_null_user }
    let(:user_params) do
      {
        jwt_with_null_user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'authorizes requests with a valid token' do
      auth = sign_in(jwt_with_null_user_session_path, user_params)

      get_with_auth('/jwt_with_null_user_auth_action', auth)

      expect(response.status).to eq(200)
    end

    it 'unauthorizes requests with an invalid token' do
      auth = 'Bearer 123'

      get_with_auth('/jwt_with_null_user_auth_action', auth)

      expect(response.status).to eq(401)
    end
  end

  context 'when a token from another scope and same id is given' do
    let(:user) { jwt_with_jti_matcher_user }
    let(:user_params) do
      {
        jwt_with_jti_matcher_user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'does not authorize a scope with another scope token' do
      auth = sign_in(jwt_with_jti_matcher_user_session_path, user_params)
      jwt_with_blacklist_user.update(id: user.id)

      get_with_auth('/jwt_with_blacklist_user_auth_action', auth)

      expect(response.status).to eq(401)
    end
  end
end
