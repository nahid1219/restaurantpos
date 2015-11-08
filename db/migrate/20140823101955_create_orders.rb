class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :table_id
      t.string :receiptno 
      t.boolean :status, :default=>true
      t.integer :total
      t.timestamps
    end
  end
end
