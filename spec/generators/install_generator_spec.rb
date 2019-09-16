# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/generators/lockable_auth/install_generator'

RSpec.describe LockableAuth::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../../tmp', __dir__)

  before :all do
    prepare_destination
    run_generator
  end

  it 'creates the installation db migration' do
    migration_file = Dir.glob("#{destination_root}/db/migrate/*add_lockable_columns_to_users.rb")

    assert_file migration_file[0], /class AddLockableColumnsToUsers < ActiveRecord::Migration/
  end
end
