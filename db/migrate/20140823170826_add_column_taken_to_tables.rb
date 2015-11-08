class AddColumnTakenToTables < ActiveRecord::Migration
  def change
    add_column :tables, :taken, :boolean,:default=>false
  end
end
