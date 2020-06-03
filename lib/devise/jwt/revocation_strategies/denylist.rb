# frozen_string_literal: true

require 'active_support/concern'

module Devise
  module JWT
    module RevocationStrategies
      # This strategy must be included in an ActiveRecord model, and requires
      # that it has a `jti` column.
      #
      # In order to tell whether a token is revoked, it just checks whether
      # `jti` is in the table. On revocation, creates a new record with it.
      module Denylist
        extend ActiveSupport::Concern

        included do
          # @see Warden::JWTAuth::Interfaces::RevocationStrategy#jwt_revoked?
          def self.jwt_revoked?(payload, _user)
            exists?(jti: payload['jti'])
          end

          # @see Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
          def self.revoke_jwt(payload, _user)
            find_or_create_by!(jti: payload['jti'],
                               exp: Time.at(payload['exp'].to_i))
          end
        end
      end
    end
  end
end
