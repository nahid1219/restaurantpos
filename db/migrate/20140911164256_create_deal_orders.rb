class CreateDealOrders < ActiveRecord::Migration
  def change
    create_table :deal_orders do |t|
      t.integer :order_id
      t.integer :deal_id
      t.integer :quantity

      t.timestamps
    end
  end
end
