# frozen_string_literal: true

require 'active_support/concern'

module Devise
  module JWT
    module Models
      # Model that will be authenticatable with the JWT strategy
      #
      # @see [Warden::JWTAuth::Interfaces::UserRepository]
      # @see [Warden::JWTAuth::Interfaces::User]
      module JWTAuthenticatable
        extend ActiveSupport::Concern

        included do
          def self.find_for_jwt_authentication(sub)
            find(sub)
          end
        end

        def jwt_subject
          id
        end
      end
    end
  end
end
