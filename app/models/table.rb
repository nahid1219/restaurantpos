class Table < ActiveRecord::Base
  has_many :orders
  validates_uniqueness_of :nmr
  validates_presence_of :nmr
  def self.empty_tables
    return (self.where taken: false).order nmr: :asc
  end
  
  def total_orders
    return self.orders.where(store_closed: true).count
  end
  
  def sum_total_orders
    return self.orders.where(store_closed: true).sum :total
  end
  
   def self.import(file_path)
    if self.all.count!=0
      self.delete_all
    end
    spreadsheet=nil
    if file_path.split(".")[1]=="xlsx"
      spreadsheet = Roo::Excelx.new(file_path, nil, :ignore)
    elsif file_path.split(".")[1]=="xls"
      spreadsheet = Roo::Excel.new(file_path, nil, :ignore)
    else
      return nil
    end
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      t=self.new row.to_hash
      t.save
    end
  end
  
end
