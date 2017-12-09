# frozen_string_literal: true

require 'devise/jwt/revocation_strategies/jti_matcher'
require 'devise/jwt/revocation_strategies/blacklist'
require 'devise/jwt/revocation_strategies/whitelist'
require 'devise/jwt/revocation_strategies/null'

module Devise
  module JWT
    # Pre-build revocation strategies
    #
    # @see Warden::JWTAuth::Interfaces::RevocationStrategy
    module RevocationStrategies
    end
  end
end
