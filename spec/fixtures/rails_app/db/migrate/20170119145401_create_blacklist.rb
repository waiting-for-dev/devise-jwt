class CreateBlacklist < ActiveRecord::Migration[5.0]
  def change
    create_table :blacklist do |t|
      t.string :jti
    end
    change_column_null :blacklist, :jti, false
  end
end
