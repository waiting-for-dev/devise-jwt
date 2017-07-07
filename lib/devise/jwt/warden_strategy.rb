# frozen_string_literal: true

module Devise
  module JWT
    # Wrapper around the Warden Stategy
    module WardenStrategy
      # Overload the authenticate! method
      def authenticate!
        super
        env['devise.skip_trackable'] = true if valid?
      end
    end
  end
end

Warden::JWTAuth::Strategy.prepend Devise::JWT::WardenStrategy
