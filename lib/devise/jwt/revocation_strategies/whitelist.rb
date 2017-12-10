# frozen_string_literal: true

require 'active_support/concern'

module Devise
  module JWT
    module RevocationStrategies
      # This strategy must be included in the user model, and requires that it
      # has a :has_many :whitelisted_jwts association.
      # The JwtWhitelist table must include `jti`, `aud` and `user_id` columns
      #
      # In order to tell whether a token is revoked, it just tries to find the
      # `jti` and `aud` values from the token on the `whitelisted_jwts`
      # table for the respective user.
      #
      # If the values don't exist means the token was revoked.
      # On revocation, it deletes the matching record from the 
      # `whitelisted_jwts` table.
      # On sign in, it creates a new record with the `jti` and `aud` values.
      module Whitelist
        extend ActiveSupport::Concern

        included do
          has_many :whitelisted_jwts, dependent: :destroy

          # @see Warden::JWTAuth::Interfaces::RevocationStrategy#jwt_revoked?
          def self.jwt_revoked?(payload, user)
            !user.whitelisted_jwts.exists?(payload.slice('jti', 'aud'))
          end

          # @see Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
          def self.revoke_jwt(payload, user)
            user.whitelisted_jwts.find_by(payload.slice('jti', 'aud')).destroy!
          end
        end

        # Warden::JWTAuth::Interfaces::User#on_jwt_dispatch
        def on_jwt_dispatch(_token, payload)
          whitelisted_jwts.create!(payload.slice('jti', 'aud'))
        end
      end
    end
  end
end
