# frozen_string_literal: true

class AddJTIColumnsTo<%= model_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column :<%= table_name_pl %>, :jti, :string, null: false
    add_index :<%= table_name_pl %>, :jti, unique: true
    # If you already have user records, you will need to initialize its `jti` column before setting it to not nullable. Your migration will look this way:
    # add_column :<%= table_name_pl %>, :jti, :string
    # User.all.each { |user| user.update_column(:jti, SecureRandom.uuid) }
    # change_column_null :<%= table_name_pl %>, :jti, false
    # add_index :<%= table_name %>, :jti, unique: true
  end
end
