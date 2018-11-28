# frozen_string_literal: true

module DeviseJwt
  module Generators
    # some functions
    module Helpers
      private

      def table_name_pl
        name.downcase.pluralize
      end

      def model_name
        name.downcase
      end

      def migration_path
        if Rails.version >= '5.0.3'
          db_migrate_path
        else
          @migration_path ||= File.join('db', 'migrate')
        end
      end

      def migration_version
        major = Rails::VERSION::MAJOR
        minon = Rails::VERSION::MINOR
        @m_version ||= "[#{major}.#{minon}]" if major >= 5
        @m_version
      end

      def model_path
        File.join('app', 'models', "#{model_name}.rb")
      end
    end
  end
end
