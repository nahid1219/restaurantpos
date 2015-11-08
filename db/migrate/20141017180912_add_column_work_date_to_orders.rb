class AddColumnWorkDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :work_date, :string, :default=>nil
  end
end
