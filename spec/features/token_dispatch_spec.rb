# frozen_string_literal: true

require 'spec_helper'

describe 'Token dispatch', type: :request do
  include_context 'fixtures'

  context 'JWT user with JTI matcher revocation' do
    let(:user_params) do
      {
        jwt_with_jti_matcher_user: {
          email: jwt_with_jti_matcher_user.email,
          password: jwt_with_jti_matcher_user.password
        }
      }
    end

    it 'dispatches JWT in sign_in requests' do
      post jwt_with_jti_matcher_user_session_path, params: user_params

      expect(response.headers['Authorization']).not_to be_nil
    end
  end
end
