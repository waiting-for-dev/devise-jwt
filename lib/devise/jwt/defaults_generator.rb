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
        model_name = inspector.class_name
        defaults[:mappings][scope] = model_name
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
        defaults[:dispatch_requests].push(*sign_in_requests(inspector))
      end

      def add_registration_request(inspector)
        return unless inspector.registration?
        defaults[:dispatch_requests].push(*registration_requests(inspector))
      end

      def add_revocation_requests(inspector)
        return unless inspector.session?
        defaults[:revocation_requests].push(*sign_out_requests(inspector))
      end

      def sign_in_requests(inspector)
        requests(inspector, :sign_in)
      end

      def sign_out_requests(inspector)
        requests(inspector, :sign_out)
      end

      def registration_requests(inspector)
        requests(inspector, :registration)
      end

      # :reek:FeatureEnvy
      def requests(inspector, name)
        path = inspector.path(name)
        method = inspector.method(name)
        inspector.formats.map do |format|
          request_for_format(path, method, format)
        end
      end

      def request_for_format(path, method, format)
        path_regexp = format ? /^#{path}.#{format}$/ : /^#{path}$/
        [method, path_regexp]
      end
    end
  end
end
