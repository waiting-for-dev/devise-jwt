# frozen_string_literal: true

require 'rails/railtie'

module Devise
  module JWT
    # Pluck to rails
    class Railtie < Rails::Railtie
      initializer 'devise-jwt' do |app|
        app.middleware.use Warden::JWTAuth::Middleware
      end
    end
  end
end
