# frozen_string_literal: true

require 'rails/railtie'

module Devise
  module JWT
    # Pluck to rails
    class Railtie < Rails::Railtie
      initializer 'devise-jwt-middleware' do |app|
        app.middleware.use Warden::JWTAuth::Middleware

        config.after_initialize do
          Rails.application.reload_routes!

          Warden::JWTAuth.configure do |config|
            defaults = DefaultsGenerator.call

            config.mappings = defaults[:mappings]
            config.dispatch_requests.push(*defaults[:dispatch_requests])
            config.revocation_requests.push(*defaults[:revocation_requests])
            config.revocation_strategies = defaults[:revocation_strategies]
          end
        end
      end
    end
  end
end
