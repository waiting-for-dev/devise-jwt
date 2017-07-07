# frozen_string_literal: true

module Devise
  module JWT
    # Overload
    module WardenStrategy
      # Overload
      def authenticate!
        super
        env['devise.skip_trackable'] = true if valid?
      end
    end
  end
end

Warden::JWTAuth::Strategy.prepend Devise::JWT::WardenStrategy
