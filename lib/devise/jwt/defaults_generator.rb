# frozen_string_literal: true

module Devise
  module JWT
    # Generate defaults to be used in the configuration for the Devise
    # installation in a Rails app
    #
    # @see Warden::JWTAuth
    class DefaultsGenerator
      attr_reader :devise_mappings, :defaults

      def self.call
        new.call
      end

      def initialize
        @devise_mappings = Devise.mappings
        @defaults = {
          mappings: {},
          revocation_strategies: {},
          dispatch_requests: [],
          revocation_requests: []
        }
      end

      def call
        devise_mappings.each do |scope, mapping|
          next unless jwt_mapping?(mapping)
          add_defaults(scope, mapping)
        end
        defaults
      end

      private

      def add_defaults(scope, mapping)
        add_mapping(scope, mapping)
        add_revocation_strategy(scope, mapping)
        add_dispatch_requests(mapping)
        add_revocation_requests(mapping)
      end

      # :reek:UtilityFunction
      def jwt_mapping?(mapping)
        mapping.modules.member?(:jwt_authenticatable)
      end

      def add_mapping(scope, mapping)
        model = mapping.to
        defaults[:mappings][scope] = model
      end

      def add_revocation_strategy(scope, mapping)
        model = mapping.to
        defaults[:revocation_strategies][scope] = model.jwt_revocation_strategy
      end

      def add_dispatch_requests(mapping)
        return unless mapping.routes.member?(:session)
        defaults[:dispatch_requests] << sign_in_request(mapping)
      end

      def add_revocation_requests(mapping)
        return unless mapping.routes.member?(:session)
        defaults[:revocation_requests] << sign_out_request(mapping)
      end

      def sign_in_request(mapping)
        path = extract_path(mapping, :sign_in)
        ['POST', /^#{path}$/]
      end

      def sign_out_request(mapping)
        path = extract_path(mapping, :sign_out)
        method = mapping.sign_out_via.to_s.upcase
        [method, /^#{path}$/]
      end

      def extract_path(mapping, name)
        prefix, scope, request = path_parts(mapping, name)
        '/' +
          (prefix ? "#{prefix}/" : '') +
          scope +
          (request ? "/#{request}" : '')
      end

      # :reek:UtilityFunction
      def path_parts(mapping, name)
        [
          mapping.instance_variable_get(:@path_prefix),
          mapping.path,
          mapping.path_names[name]
        ]
      end
    end
  end
end
