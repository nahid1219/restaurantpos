class RenameColumnImagePathToCategoryInMeals < ActiveRecord::Migration
  def change
    rename_column :meals,:image_path,:category
  end
end
