Rails.application.routes.draw do
  devise_for :no_jwt_users
  devise_for :jwt_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
