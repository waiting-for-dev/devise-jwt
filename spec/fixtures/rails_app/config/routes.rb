Rails.application.routes.draw do
  devise_for :no_jwt_users, defaults: { format: :json }
  devise_for :jwt_with_jti_matcher_users, defaults: { format: :json }
  devise_for :jwt_with_blacklist_users, defaults: { format: :json }
  devise_for :jwt_with_null_users, defaults: { format: :json }
end
