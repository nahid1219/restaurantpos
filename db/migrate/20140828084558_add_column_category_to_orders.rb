class AddColumnCategoryToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :category, :boolean
  end
end
