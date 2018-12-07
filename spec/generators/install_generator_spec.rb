require "generator_spec"

module LockableAuth
  module Generators
    describe 'InstallGenerator', :type => :generator do

      destination File.expand_path("../../tmp", __FILE__)

      before :all do
        prepare_destination
        run_generator
      end

      it "creates the installation db migration" do
        migration_file = 
          Dir.glob("#{root_dir}/db/migrate/*add_lockable_columns_to_users.rb")

        assert_file migration_file[0], 
          /class AddLockableColumnsToUsers < ActiveRecord::Migration/
      end
		end
	end		
end