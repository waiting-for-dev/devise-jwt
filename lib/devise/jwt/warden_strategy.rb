# frozen_string_literal: true

module Devise
  module JWT
    module WardenStrategy
      # Overload
      def authenticate!
        super
        env['devise.skip_trackable'.freeze] = true if self.valid?
      end
    end
  end
end

Warden::JWTAuth::Strategy.prepend Devise::JWT::WardenStrategy
