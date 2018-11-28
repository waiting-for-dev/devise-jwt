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

      def rails5_and_up?
        Rails::VERSION::MAJOR >= 5
      end

      def migration_version
        if rails5_and_up?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end

      def model_path
        File.join('app', 'models', "#{model_name}.rb")
      end
    end
  end
end
