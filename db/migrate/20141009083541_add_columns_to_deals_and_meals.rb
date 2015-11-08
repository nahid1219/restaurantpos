class AddColumnsToDealsAndMeals < ActiveRecord::Migration
  def up
    add_column :meal_orders,:ticket_number,:integer
    add_column :deal_orders,:ticket_number,:integer
  end
  def down
    remove_column :meal_orders,:ticket_number
    remove_column :deal_orders,:ticket_number
  end
end
