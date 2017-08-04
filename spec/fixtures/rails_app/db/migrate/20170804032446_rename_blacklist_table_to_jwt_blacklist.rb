class RenameBlacklistTableToJwtBlacklist < ActiveRecord::Migration[5.1]
  def change
    rename_table :blacklist, :jwt_blacklist
  end
end