class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.string :name_english
      t.string :name_urdu, :default=>""
      t.integer :price
      t.timestamps
    end
  end
end
