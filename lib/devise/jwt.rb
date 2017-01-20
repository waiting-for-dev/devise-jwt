# frozen_string_literal: true

require 'devise'
require 'active_support/core_ext/module/attribute_accessors'
require 'warden/jwt_auth'
require 'devise/jwt/version'
require 'devise/jwt/defaults_generator'
require 'devise/jwt/railtie'
require 'devise/jwt/models'
require 'devise/jwt/revocation_strategies'

# Authentication library
module Devise
  # Yields to Warden::JWTAuth.config
  #
  # @see Warden::JWTAuth
  def self.jwt
    yield(Warden::JWTAuth.config)
  end

  add_module(:jwt_authenticatable, strategy: :jwt)

  # JWT extension for devise
  module JWT
  end
end
