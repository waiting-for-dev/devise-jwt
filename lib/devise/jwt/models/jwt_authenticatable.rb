# frozen_string_literal: true

require 'active_support/concern'

module Devise
  module Models
    # Model that will be authenticatable with the JWT strategy
    #
    # @see [Warden::JWTAuth::Interfaces::UserRepository]
    # @see [Warden::JWTAuth::Interfaces::User]
    module JwtAuthenticatable
      extend ActiveSupport::Concern

      class_methods do
        Devise::Models.config(self, :jwt_revocation_strategy)
      end

      included do
        def self.find_for_jwt_authentication(sub)
          find_by(jwt_subject_key => sub)
        end

        def self.jwt_subject_key
          primary_key
        end
      end

      def jwt_subject
        send(self.jwt_subject_key)
      end
    end
  end
end
