class AddColumnCategoryToMealOrders < ActiveRecord::Migration
  def up
    add_column :meal_orders, :category, :string, :default=>"full"
  end
  def down
    remove_column :meal_orders, :category
  end
end
