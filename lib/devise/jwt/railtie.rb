# frozen_string_literal: true

require 'rails/railtie'

module Devise
  module JWT
    # Pluck to rails
    class Railtie < Rails::Railtie
      initializer 'devise-jwt-middleares' do |app|
        app.middleware.use Warden::JWTAuth::Middleware
      end

      config.after_initialize do
        # A way to avoid this?
        Rails.application.reload_routes!

        Warden::JWTAuth.configure do |config|
          config.mappings =
            Devise.mappings.each_with_object({}) do |tuple, hash|
              scope, devise_mapping = tuple
              modules = devise_mapping.modules
              next unless modules.include?(:jwt_authenticatable)
              hash[scope] = devise_mapping.to
            end

          config.dispatch_requests =
            begin
              routes = Rails.application.routes
              scopes = config.mappings.keys
              scopes.each_with_object([]) do |scope, array|
                named_route = "#{scope}_session"
                named_path = "#{named_route}_path"
                route = routes.named_routes[named_route]
                next unless route
                method = route.verb
                array << [method, /^#{routes.url_helpers.send(named_path)}$/]
              end
            end
        end
      end
    end
  end
end
