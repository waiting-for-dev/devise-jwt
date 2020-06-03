class RenameBlacklistToDenylist < ActiveRecord::Migration[6.0]
  def change
    rename_table :jwt_blacklist, :jwt_denylist
    rename_table :jwt_with_blacklist_users, :jwt_with_denylist_users
  end
end
