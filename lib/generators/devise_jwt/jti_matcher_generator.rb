# frozen_string_literal: true

require 'rails/generators/active_record'
require_relative 'helpers'

module DeviseJwt
  module Generators
    # Generator for JTIMatcher revocation strategy
    class JtiMatcherGenerator < ActiveRecord::Generators::Base
      desc <<-DESC.strip_heredoc
        Set up JTIMatcher revocation strategy.

        For example:
          rails g devise_jwt:jti_matcher User
          rails g devise_jwt:jti_matcher Admin
      DESC

      include DeviseJwt::Generators::Helpers
      source_root File.expand_path('templates', __dir__)

      def copy_migration
        migration_template(
          'migration_jti.erb',
          "#{migration_path}/add_jti_columns_to_#{table_name}.rb",
          migration_version: migration_version
        )
      end

      def inject_devise_content
        content = <<-CONTENT
  # jti_matcher
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  # jti_matcher
        CONTENT

        if File.exist?(model_path)
          inject_into_class(model_path, model_name.camelize, content)
        else
          puts "Warning: #{model_path} does not exist!"
        end
      end

      def print_information
        [
          'New migration was created.',
          "Then, open #{model_path} and finish configurating",
          '',
          'If you have any questions, open https://github.com/waiting-for-dev/devise-jwt#jtimatcher'
        ].each do |str|
          puts str
        end
      end
    end
  end
end
