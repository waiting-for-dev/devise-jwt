# frozen_string_literal: true

require 'rails/generators/active_record'
require_relative 'helpers'

module DeviseJwt
  module Generators
    # Generator class for whitelist revocation strategy
    class WhitelistGenerator < ActiveRecord::Generators::Base
      desc <<-DESC.strip_heredoc
        Set up Whitelist revocation strategy.

        For example:
          rails g devise_jwt:whitelist User
          rails g devise_jwt:whitelist Admin
      DESC

      include DeviseJwt::Generators::Helpers
      source_root File.expand_path('templates', __dir__)

      def copy_migration
        migration_template(
          'migration_whitelist.rb',
          "#{migration_path}/devise_jwt_create_jwt_whitelist.rb",
          migration_version: migration_version
        )
      end

      def generate_model
        model_subpath = 'app/models/whitelisted_jwt.rb'
        model_path = Rails.root.join(model_subpath)

        return if File.exist?(model_path)

        invoke(
          'active_record:model',
          ['WhitelistedJwt'],
          migration: false
        )
      end

      def inject_devise_content
        content = <<-CONTENT
  # whitelist
  include Devise::JWT::RevocationStrategies::Whitelist

  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  # whitelist
        CONTENT

        if File.exist?(model_path)
          inject_into_class(
            model_path,
            model_name.camelize,
            content
          )
        else
          puts "Warning: #{model_path} does not exist!"
        end
      end

      def print_information
        [
          'New migration and a model were created.',
          "Then, open #{model_path} and finish configurating",
          '',
          'If you have any questions, see https://github.com/waiting-for-dev/devise-jwt#whitelist'
        ].each do |str|
          puts str
        end
      end
    end
  end
end
