class RenameWhitelistToAllowlist < ActiveRecord::Migration[6.0]
  def change
    rename_table :whitelisted_jwts, :allowlisted_jwts
    rename_table :jwt_with_whitelist_users, :jwt_with_allowlist_users
    rename_column :allowlisted_jwts, :jwt_with_whitelist_user_id, :jwt_with_allowlist_user_id
  end
end
