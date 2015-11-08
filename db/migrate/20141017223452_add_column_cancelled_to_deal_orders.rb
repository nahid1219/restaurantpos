class AddColumnCancelledToDealOrders < ActiveRecord::Migration
  def change
    add_column :deal_orders, :cancelled, :boolean,:default=>false
  end
end
