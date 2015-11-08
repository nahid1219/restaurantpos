class AddColumnImagePathToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :image_path, :string, :default=>""
  end
end
