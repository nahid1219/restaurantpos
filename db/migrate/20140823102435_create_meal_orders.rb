class CreateMealOrders < ActiveRecord::Migration
  def change
    create_table :meal_orders do |t|
      t.integer :meal_id
      t.integer :order_id
      t.integer :quantity
      t.timestamps
    end
  end
end
