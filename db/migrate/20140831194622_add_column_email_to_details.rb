class AddColumnEmailToDetails < ActiveRecord::Migration
  def change
    add_column :details, :email, :string
  end
end
