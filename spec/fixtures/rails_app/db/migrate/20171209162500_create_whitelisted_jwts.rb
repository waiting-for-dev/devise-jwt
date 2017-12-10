class CreateWhitelistedJwts < ActiveRecord::Migration[5.0]
  def change
    create_table :whitelisted_jwts do |t|
      t.string :jti, null: false, index: { unique: true }
      t.string :aud
      t.references :jwt_with_whitelist_user, foreign_key: true
    end
  end
end
