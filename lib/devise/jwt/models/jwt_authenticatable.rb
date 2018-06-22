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
          find_by(primary_key => sub)
        end
      end

      def jwt_subject
        id
      end
    end
  end
end
