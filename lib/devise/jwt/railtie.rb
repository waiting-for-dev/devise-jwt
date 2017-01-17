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
        Rails.application.reload_routes!

        Warden::JWTAuth.configure do |config|
          defaults = DefaultsGenerator.new

          config.mappings = defaults.mappings
          config.dispatch_requests = defaults.dispatch_requests
          config.revocation_requests = defaults.revocation_requests
        end
      end
    end
  end
end
