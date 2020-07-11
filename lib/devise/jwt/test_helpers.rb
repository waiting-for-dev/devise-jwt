# frozen_string_literal: true

module Devise
  module JWT
    # Helpers to make testing authorization through JWT easier
    module TestHelpers
      # Returns headers with a valid token in the `Authorization` header
      # added.
      #
      # Side effects could happen if you have implemented
      # `on_jwt_dispatch` method on the user model (as it happens in
      # the allowlist revocation strategy).
      #
      # Be aware that a fresh copy of `headers` is returned with the new
      # key/value pair added, instead of modifying given argument.
      #
      # @param headers [Hash] Headers to which add the `Authorization` item.
      # @param user [ActiveRecord::Base] The user to authenticate.
      # @param scope [Symbol] The warden scope. If `nil` it will be
      # autodetected.
      # @param aud [String] The aud claim. If `nil` it will be autodetected from
      # the header name configured in `Devise::JWT.config.aud_header`.
      def self.auth_headers(headers, user, scope: nil, aud: nil)
        scope ||= Devise::Mapping.find_scope!(user)
        aud ||= headers[Warden::JWTAuth.config.aud_header]
        token, payload = Warden::JWTAuth::UserEncoder.new.call(
          user, scope, aud
        )
        user.on_jwt_dispatch(token, payload) if user.respond_to?(:on_jwt_dispatch)
        Warden::JWTAuth::HeaderParser.to_headers(headers, token)
      end
    end
  end
end
