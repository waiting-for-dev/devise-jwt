class RenameJwtUserToJwtWithJtiMatcherUsers < ActiveRecord::Migration[5.0]
  def change
    rename_table :jwt_users, :jwt_with_jti_matcher_users
  end
end
