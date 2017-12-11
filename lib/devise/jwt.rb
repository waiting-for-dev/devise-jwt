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

    setting(:secret) do |value|
      forward_to_warden(:secret, value)
    end

    setting(:expiration_time) do |value|
      forward_to_warden(:expiration_time, value)
    end

    setting(:dispatch_requests) do |value|
      forward_to_warden(:dispatch_requests, value)
    end

    setting(:revocation_requests) do |value|
      forward_to_warden(:revocation_requests, value)
    end

    setting(:aud_header) do |value|
      forward_to_warden(:aud_header, value)
    end

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
    setting :request_formats, {}

    def self.forward_to_warden(setting, value)
      Warden::JWTAuth.config.send("#{setting}=", value)
    end
  end
end
