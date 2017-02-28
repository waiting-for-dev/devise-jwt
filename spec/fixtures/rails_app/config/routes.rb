Rails.application.routes.draw do
  get '/jwt_with_jti_matcher_user_auth_action',
      to: 'application#jwt_with_jti_matcher_user_auth_action',
      defauts: { format: :json }

  get '/jwt_with_blacklist_user_auth_action',
      to: 'application#jwt_with_blacklist_user_auth_action',
      defauts: { format: :json }

  get '/jwt_with_null_user_auth_action',
      to: 'application#jwt_with_null_user_auth_action',
      defauts: { format: :json }

  devise_for :no_jwt_users,
             defaults: { format: :json }

  devise_for :jwt_with_jti_matcher_users,
             defaults: { format: :json }

  devise_for :jwt_with_blacklist_users,
             defaults: { format: :json }

  scope 'a/scope' do
    devise_for :jwt_with_null_users,
               defaults: { format: :json },
               sign_out_via: :post
  end
end
