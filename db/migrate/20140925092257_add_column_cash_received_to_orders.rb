class AddColumnCashReceivedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cash_received, :boolean, :default=>false
  end
end
