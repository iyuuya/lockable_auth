class AddLockableColumnsToUsers < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def change
    add_column :users, :locked_at, :datetime
    add_column :users, :failed_attempts, :integer, default: 0, null: false
  end
end
