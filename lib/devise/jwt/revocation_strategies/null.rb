# frozen_string_literal: true

require 'active_support/concern'

module Devise
  module JWT
    module RevocationStrategies
      # This strategy is just a null object pattern strategy, so it does not
      # revoke anything
      module Null
        # @see Warden::JWTAuth::Interfaces::RevocationStrategy#jwt_revoked?
        def self.jwt_revoked?(_payload, _user)
          false
        end

        # @see Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
        def self.revoke_jwt(_payload, _user); end
      end
    end
  end
end
