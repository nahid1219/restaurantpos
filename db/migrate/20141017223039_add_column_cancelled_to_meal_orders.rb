class AddColumnCancelledToMealOrders < ActiveRecord::Migration
  def change
    add_column :meal_orders, :cancelled, :boolean,:default=>false
  end
end
