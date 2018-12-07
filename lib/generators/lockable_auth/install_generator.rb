require 'rails/generators/migration'

module LockableAuth
	module Generators
		class InstallGenerator < ::Rails::Generators::Base
			include Rails::Generators::Migration
			source_root File.expand_path('../templates', __FILE__)
			desc "Add the migrations for Lockable"

			def self.next_migration_number(path)
        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def copy_migrations
        migration_template "add_lockable_columns_to_users.rb",
          "db/migrate/add_lockable_columns_to_users.rb"
      end
			
		end
		
	end
end