class AddColumnChangeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :change, :integer, :default=>0
  end
end
