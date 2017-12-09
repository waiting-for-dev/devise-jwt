class RenameBlacklistTableToJwtBlacklist < ActiveRecord::Migration[5.0]
  def change
    rename_table :blacklist, :jwt_blacklist
  end
end