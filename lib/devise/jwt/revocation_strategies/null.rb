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

        # @see Warden::JWTAuth::Interfaces::RevocationStrategy#jwt_revoke
        def self.jwt_revoke(_payload, _user); end
      end
    end
  end
end
