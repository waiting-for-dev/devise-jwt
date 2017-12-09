class AddExpirationTimeToBlacklist < ActiveRecord::Migration[5.0]
  def change
    add_column :blacklist, :exp, :datetime, null: false, default: Time.now
  end
end
