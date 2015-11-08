class RenameColumnEmailToUserNameInUsers < ActiveRecord::Migration
  def change
    rename_column :users,:email,:user_name
  end
end
