# frozen_string_literal: true

require 'active_support/core_ext/module/attribute_accessors'
require 'warden/jwt_auth'
require 'devise/jwt/version'
require 'devise/jwt/railtie'

# Authentication library
module Devise
  # Just defines JWTAuth settings as devise settings for convenience, prepending
  # names with 'jwt'
  #
  # @see [Warden::JWTAuth]
  Warden::JWTAuth.config.to_h.keys.each do |setting|
    mattr_accessor("jwt_#{setting}")

    define_singleton_method("jwt_#{setting}=") do |value|
      class_variable_set("@@jwt_#{setting}", value)
      Warden::JWTAuth.config.send("#{setting}=", value)
    end
  end

  # JWT extension for devise
  module JWT
  end
end
