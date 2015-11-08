class RemoveColumnPriceFromMeals < ActiveRecord::Migration
  def up
    remove_column :meals, :price
  end
  def down
    add_column :meals, :price, :integer
  end
end
