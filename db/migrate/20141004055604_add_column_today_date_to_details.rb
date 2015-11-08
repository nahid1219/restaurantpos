class AddColumnTodayDateToDetails < ActiveRecord::Migration
  def change
    add_column :details, :today_date, :datetime,:default=>nil
  end
end
