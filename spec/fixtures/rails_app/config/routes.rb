Rails.application.routes.draw do
  devise_for :no_jwt_users
  devise_for :jwt_with_jti_matcher_users, defaults: { format: :json }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
