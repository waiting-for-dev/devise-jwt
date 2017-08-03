class AddRevokedAtAndExpirationTimeToBlacklist < ActiveRecord::Migration[5.1]
  def change
    add_column :blacklist, :revoked_at, :datetime, default: Time.now
    add_column :blacklist, :expiration_time, :datetime
  end
end
