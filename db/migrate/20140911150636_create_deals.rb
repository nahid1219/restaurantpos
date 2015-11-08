class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :name
      t.integer :deal_no
      t.string :category
      t.text :contents
      t.integer :price

      t.timestamps
    end
  end
end
