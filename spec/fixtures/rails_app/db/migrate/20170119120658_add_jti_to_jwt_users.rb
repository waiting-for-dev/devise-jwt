class AddJtiToJwtUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :jwt_users, :jti, :string
    change_column_null :jwt_users, :jti, false
  end
end
