class AddColumnStoreClosedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :store_closed, :boolean,:default=>false
  end
end
