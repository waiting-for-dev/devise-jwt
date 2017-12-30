class AddUniqueIndexToBlacklistJti < ActiveRecord::Migration[5.1]
  def change
    add_index :jwt_blacklist, :jti, unique: true
  end
end
