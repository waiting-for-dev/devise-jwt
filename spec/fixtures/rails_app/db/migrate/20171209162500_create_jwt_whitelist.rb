class CreateJwtWhitelist < ActiveRecord::Migration[5.0]
  def change
    create_table :jwt_whitelists do |t|
      t.string :jti, null: false, index: { unique: true }
      t.string :aud, null: false
      t.references :jwt_with_whitelist_user, foreign_key: true
    end
  end
end
