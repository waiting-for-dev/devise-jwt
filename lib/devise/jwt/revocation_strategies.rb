# frozen_string_literal: true

require 'devise/jwt/revocation_strategies/jti_matcher'
require 'devise/jwt/revocation_strategies/denylist'
require 'devise/jwt/revocation_strategies/allowlist'
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
