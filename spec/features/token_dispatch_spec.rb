# frozen_string_literal: true

require 'spec_helper'

describe 'Token dispatch', type: :request do
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

    it 'dispatches JWT in sign_in requests' do
      post jwt_with_jti_matcher_user_session_path, params: user_params

      expect(response.headers['Authorization']).not_to be_nil
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

    it 'dispatches JWT in sign_in requests' do
      post jwt_with_blacklist_user_session_path, params: user_params

      expect(response.headers['Authorization']).not_to be_nil
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

    it 'dispatches JWT in sign_in requests' do
      post jwt_with_null_user_session_path, params: user_params

      expect(response.headers['Authorization']).not_to be_nil
    end
  end

  context 'no JWT user' do
    let(:user) { no_jwt_user }
    let(:user_params) do
      {
        no_jwt_user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'does not dispatch JWT in sign_in requests' do
      post no_jwt_user_session_path, params: user_params

      expect(response.headers['Authorization']).to be_nil
    end
  end
end
