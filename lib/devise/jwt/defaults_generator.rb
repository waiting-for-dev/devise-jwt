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
        devise_mappings.each_key do |scope|
          inspector = MappingInspector.new(scope)
          next unless inspector.jwt?
          add_defaults(inspector)
        end
        defaults
      end

      private

      def add_defaults(inspector)
        add_mapping(inspector)
        add_revocation_strategy(inspector)
        add_dispatch_requests(inspector)
        add_revocation_requests(inspector)
      end

      # :reek:FeatureEnvy
      def add_mapping(inspector)
        scope = inspector.scope
        model = inspector.model
        defaults[:mappings][scope] = model
      end

      # :reek:FeatureEnvy
      def add_revocation_strategy(inspector)
        scope = inspector.scope
        model = inspector.model
        defaults[:revocation_strategies][scope] = model.jwt_revocation_strategy
      end

      def add_dispatch_requests(inspector)
        add_sign_in_request(inspector)
        add_registration_request(inspector)
      end

      def add_sign_in_request(inspector)
        return unless inspector.session?
        defaults[:dispatch_requests] << sign_in_request(inspector)
      end

      def add_registration_request(inspector)
        return unless inspector.registration?
        defaults[:dispatch_requests] << registration_request(inspector)
      end

      def add_revocation_requests(inspector)
        return unless inspector.session?
        defaults[:revocation_requests] << sign_out_request(inspector)
      end

      def sign_in_request(inspector)
        request(inspector, :sign_in)
      end

      def sign_out_request(inspector)
        request(inspector, :sign_out)
      end

      def registration_request(inspector)
        request(inspector, :registration)
      end

      # :reek:UtilityFunction
      def request(inspector, name)
        path = inspector.path(name)
        method = inspector.method(name)
        [method, /^#{path}$/]
      end
    end
  end
end
