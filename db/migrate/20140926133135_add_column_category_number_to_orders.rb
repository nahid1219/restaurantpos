class AddColumnCategoryNumberToOrders < ActiveRecord::Migration
  def change
    add_column :meals, :category_number, :integer
  end
end
