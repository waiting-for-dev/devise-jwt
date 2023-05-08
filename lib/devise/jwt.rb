# frozen_string_literal: true

require 'forwardable'
require 'devise'
require 'active_support/core_ext/module/attribute_accessors'
require 'warden/jwt_auth'
require 'devise/jwt/version'
require 'devise/jwt/mapping_inspector'
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
    yield(Devise::JWT.config)
  end

  add_module(:jwt_authenticatable, strategy: :jwt)

  # JWT extension for devise
  module JWT
    extend Dry::Configurable

    def self.forward_to_warden(setting, value)
      default = Warden::JWTAuth.config.send(setting)
      Warden::JWTAuth.config.send("#{setting}=", value || default)
      Warden::JWTAuth.config.send(setting)
    end

    setting(:secret,
            default: Warden::JWTAuth.config.secret,
            constructor: ->(value) { forward_to_warden(:secret, value) })

    setting(:rotation_secret,
            default: Warden::JWTAuth.config.rotation_secret,
            constructor: ->(value) { forward_to_warden(:rotation_secret, value) })

    setting(:decoding_secret,
            constructor: ->(value) { forward_to_warden(:decoding_secret, value) })

    setting(:algorithm,
            constructor: ->(value) { forward_to_warden(:algorithm, value) })

    setting(:expiration_time,
            default: Warden::JWTAuth.config.expiration_time,
            constructor: ->(value) { forward_to_warden(:expiration_time, value) })

    setting(:dispatch_requests,
            default: Warden::JWTAuth.config.dispatch_requests,
            constructor: ->(value) { forward_to_warden(:dispatch_requests, value) })

    setting(:revocation_requests,
            default: Warden::JWTAuth.config.revocation_requests,
            constructor: ->(value) { forward_to_warden(:revocation_requests, value) })

    setting(:aud_header,
            default: Warden::JWTAuth.config.aud_header,
            constructor: ->(value) { forward_to_warden(:aud_header, value) })

    # A hash of warden scopes as keys and an array of request formats that will
    # be processed as values. When a scope is not present or if it has a nil
    # item, requests without format will be taken into account.
    #
    # For example, with following configuration, `user` scope would dispatch and
    # revoke tokens in `json` requests, while `admin_user` would do it in `xml`
    # and with no format.
    #
    # @example
    # {
    #   user: [:json],
    #   admin_user: [nil, :xml]
    # }
    setting :request_formats, default: {}
  end
end
