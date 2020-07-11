# frozen_string_literal: true

require 'active_support/concern'

module Devise
  module JWT
    module RevocationStrategies
      # This strategy must be included in the user model.
      #
      # The JwtAllowlist table must include `jti`, `aud`, `exp` and `user_id`
      # columns
      #
      # In order to tell whether a token is revoked, it just tries to find the
      # `jti` and `aud` values from the token on the `allowlisted_jwts`
      # table for the respective user.
      #
      # If the values don't exist means the token was revoked.
      # On revocation, it deletes the matching record from the
      # `allowlisted_jwts` table.
      #
      # On sign in, it creates a new record with the `jti` and `aud` values.
      module Allowlist
        extend ActiveSupport::Concern

        included do
          has_many :allowlisted_jwts, dependent: :destroy

          # @see Warden::JWTAuth::Interfaces::RevocationStrategy#jwt_revoked?
          def self.jwt_revoked?(payload, user)
            !user.allowlisted_jwts.exists?(payload.slice('jti', 'aud'))
          end

          # @see Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
          def self.revoke_jwt(payload, user)
            jwt = user.allowlisted_jwts.find_by(payload.slice('jti', 'aud'))
            jwt.destroy! if jwt
          end
        end

        # Warden::JWTAuth::Interfaces::User#on_jwt_dispatch
        def on_jwt_dispatch(_token, payload)
          allowlisted_jwts.create!(
            jti: payload['jti'],
            aud: payload['aud'],
            exp: Time.at(payload['exp'].to_i)
          )
        end
      end
    end
  end
end
