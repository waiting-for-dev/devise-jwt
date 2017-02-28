# frozen_string_literal: true

require 'spec_helper'

describe 'Token revocation', type: :request do
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

    it 'revokes JWT in sign_out' do
      auth = sign_in(jwt_with_jti_matcher_user_session_path, user_params)
      sign_out(destroy_jwt_with_jti_matcher_user_session_path, auth)

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

    it 'revokes JWT in sign_out' do
      auth = sign_in(jwt_with_blacklist_user_session_path, user_params)
      sign_out(destroy_jwt_with_blacklist_user_session_path, auth, :post)

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

    it 'does not revoke JWT' do
      auth = sign_in(jwt_with_null_user_session_path, user_params)
      sign_out(destroy_jwt_with_null_user_session_path, auth)

      get_with_auth('/jwt_with_null_user_auth_action', auth)

      expect(response.status).to eq(200)
    end
  end
end
