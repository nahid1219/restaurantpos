class Updateschema < ActiveRecord::Migration
  def change
    drop_table :users
    remove_column :orders,:user_id
  end
end
