class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :file_path
      t.string :file_date
      t.timestamps
    end
  end
end
