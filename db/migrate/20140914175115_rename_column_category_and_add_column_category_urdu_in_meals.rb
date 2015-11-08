class RenameColumnCategoryAndAddColumnCategoryUrduInMeals < ActiveRecord::Migration
  def change
    rename_column :meals,:category,:category_english
    add_column :meals,:category_urdu,:string
  end
end
