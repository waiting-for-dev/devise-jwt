# frozen_string_literal: true

require 'spec_helper'

describe 'Token dispatch', type: :request do
  include_context 'feature'
  include_context 'fixtures'

  let(:generic_registration_params) do
    {
      email: 'registration@email.com',
      password: 'password'
    }
  end

  context 'JWT user with JTI matcher revocation' do
    let(:user) { jwt_with_jti_matcher_user }
    let(:sign_in_params) do
      {
        jwt_with_jti_matcher_user: {
          email: user.email,
          password: user.password
        }
      }
    end
    let(:registration_params) do
      {
        jwt_with_jti_matcher_user: generic_registration_params
      }
    end

    it 'dispatches JWT in sign_in requests' do
      sign_in(jwt_with_jti_matcher_user_session_path, sign_in_params)

      expect(response.headers['Authorization']).not_to be_nil
    end

    it 'dispatches JWT in registration requests' do
      sign_up(jwt_with_jti_matcher_user_registration_path, registration_params)

      expect(response.headers['Authorization']).not_to be_nil
    end
  end

  context 'JWT user with Denylist revocation' do
    let(:user) { jwt_with_denylist_user }
    let(:sign_in_params) do
      {
        jwt_with_denylist_user: {
          email: user.email,
          password: user.password
        }
      }
    end
    let(:registration_params) do
      {
        jwt_with_denylist_user: generic_registration_params
      }
    end

    it 'dispatches JWT in sign_in requests' do
      sign_in(
        jwt_with_denylist_user_session_path, sign_in_params, format: :json
      )

      expect(response.headers['Authorization']).not_to be_nil
    end

    it 'dispatches JWT in registration requests' do
      sign_up(
        jwt_with_denylist_user_registration_path,
        registration_params, format: :json
      )

      expect(response.headers['Authorization']).not_to be_nil
    end
  end

  context 'JWT user with allowlist revocation' do
    let(:user) { jwt_with_allowlist_user }
    let(:sign_in_params) do
      {
        jwt_with_allowlist_user: {
          email: user.email,
          password: user.password
        }
      }
    end
    let(:registration_params) do
      {
        jwt_with_allowlist_user: generic_registration_params
      }
    end

    it 'dispatches JWT in sign_in requests' do
      sign_in(jwt_with_allowlist_user_session_path, sign_in_params)

      expect(response.headers['Authorization']).not_to be_nil
    end

    it 'dispatches JWT in registration requests' do
      sign_up(jwt_with_allowlist_user_registration_path, registration_params)

      expect(response.headers['Authorization']).not_to be_nil
    end
  end

  context 'JWT user with Null revocation' do
    let(:user) { jwt_with_null_user }
    let(:sign_in_params) do
      {
        jwt_with_null_user: {
          email: user.email,
          password: user.password
        }
      }
    end
    let(:registration_params) do
      {
        jwt_with_null_user: generic_registration_params
      }
    end

    it 'dispatches JWT in sign_in requests' do
      sign_in(jwt_with_null_user_session_path, sign_in_params)

      expect(response.headers['Authorization']).not_to be_nil
    end

    it 'dispatches JWT in registration requests' do
      sign_up(jwt_with_null_user_registration_path, registration_params)

      expect(response.headers['Authorization']).not_to be_nil
    end
  end

  context 'no JWT user' do
    let(:user) { no_jwt_user }
    let(:sign_in_params) do
      {
        no_jwt_user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'does not dispatch JWT in sign_in requests' do
      sign_in(no_jwt_user_session_path, sign_in_params)

      expect(response.headers['Authorization']).to be_nil
    end
  end
end
