class AddColumnAmountReceivedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :amount_received, :integer, :default=>0
  end
end
