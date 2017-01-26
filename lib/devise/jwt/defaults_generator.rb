# frozen_string_literal: true

module Devise
  module JWT
    # Generate defaults to be used in the configuration for the Devise
    # installation in a Rails app
    #
    # @see Warden::JWTAuth
    class DefaultsGenerator
      attr_reader :routes, :devise_mappings

      def initialize
        @routes = Rails.application.routes
        @devise_mappings = Devise.mappings
      end

      def mappings
        @mappings ||= devise_mappings.each_with_object({}) do |tuple, hash|
          scope, mapping = tuple
          modules = mapping.modules
          next unless modules.include?(:jwt_authenticatable)
          hash[scope] = mapping.to
        end
      end

      def dispatch_requests
        scopes.each_with_object([]) do |scope, array|
          named_route = "#{scope}_session"
          array << request_for(named_route)
        end
      end

      def revocation_requests
        scopes.each_with_object([]) do |scope, array|
          named_route = "destroy_#{scope}_session"
          array << request_for(named_route)
        end
      end

      def revocation_strategies
        mappings.each_with_object({}) do |tuple, hash|
          scope, model = tuple
          hash[scope] = model.jwt_revocation_strategy
        end
      end

      private

      def scopes
        mappings.keys
      end

      def request_for(named_route)
        named_path = "#{named_route}_path"
        route = routes.named_routes[named_route]
        method = method_for_route(route)
        path = /^#{routes.url_helpers.send(named_path)}$/
        [method, path]
      end

      # :reek:UtilityFunction
      # @see https://github.com/rails/rails/pull/21849
      def method_for_route(route)
        verb = route.verb
        if Rails.version.to_i < 5
          verb.source.match(/\w+/)[0]
        else
          verb
        end
      end
    end
  end
end
