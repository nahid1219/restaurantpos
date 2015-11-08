class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.string :name
      t.string :city
      t.string :phone1
      t.string :phone2
      t.string :address

      t.timestamps
    end
  end
end
