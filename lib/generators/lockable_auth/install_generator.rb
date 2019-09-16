# frozen_string_literal: true

require 'rails/generators' unless defined? ::Rails::Generators
require 'active_record' unless defined? ActiveRecord::Migration

if defined? ::Rails::Generators && defined? ActiveRecord::Migration
  module LockableAuth
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include Rails::Generators::Migration
        source_root File.expand_path('templates', __dir__)
        desc 'Add the migrations for Lockable'

        def self.next_migration_number(path)
          next_migration_number = current_migration_number(path) + 1
          ActiveRecord::Migration.next_migration_number(next_migration_number)
        end

        def copy_migrations
          migration_template 'add_lockable_columns_to_users.rb.erb',
                             'db/migrate/add_lockable_columns_to_users.rb'
        end
      end
    end
  end
end
