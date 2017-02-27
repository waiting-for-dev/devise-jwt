# frozen_string_literal: true

module Devise
  module JWT
    # Generate defaults to be used in the configuration for the Devise
    # installation in a Rails app
    #
    # @see Warden::JWTAuth
    class DefaultsGenerator
      attr_reader :devise_mappings

      def initialize
        @devise_mappings = Devise.mappings.select do |_scope, mapping|
          mapping.modules.member?(:jwt_authenticatable)
        end
      end

      def mappings
        @mappings ||= devise_mappings.each_with_object({}) do |tuple, hash|
          scope, mapping = tuple
          hash[scope] = mapping.to
        end
      end

      def dispatch_requests
        devise_mappings.each_with_object([]) do |tuple, array|
          _scope, mapping = tuple
          next unless mapping.routes.member?(:session)
          array << sign_in_request(mapping)
        end
      end

      def revocation_requests
        devise_mappings.each_with_object([]) do |tuple, array|
          _scope, mapping = tuple
          next unless mapping.routes.member?(:session)
          array << sign_out_request(mapping)
        end
      end

      def revocation_strategies
        mappings.each_with_object({}) do |tuple, hash|
          scope, model = tuple
          hash[scope] = model.jwt_revocation_strategy
        end
      end

      private

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
