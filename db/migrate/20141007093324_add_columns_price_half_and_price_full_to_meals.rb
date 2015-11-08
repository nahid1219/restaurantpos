class AddColumnsPriceHalfAndPriceFullToMeals < ActiveRecord::Migration
  def up
    add_column :meals, :price_full, :integer
    add_column :meals, :price_half, :integer
  end
  def down
    remove_column :meals, :price_full
    remove_column :meals, :price_half
  end
end
