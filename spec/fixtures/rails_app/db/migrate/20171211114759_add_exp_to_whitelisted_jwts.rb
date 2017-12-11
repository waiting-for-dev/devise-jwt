class AddExpToWhitelistedJwts < ActiveRecord::Migration[5.1]
  def change
    add_column :whitelisted_jwts, :exp, :datetime, null: false, default: Time.now
  end
end
