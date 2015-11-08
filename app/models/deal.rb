class Deal < ActiveRecord::Base
  has_many :deal_orders
  has_many :orders,:through=>:deal_orders
  #serialize :contents
  def get_contents
    if contents==nil
      return nil
    end
    contents_hash={}
    tmp=contents.split("|")
    tmp.each do |t|
      s=t.split(",")
      contents_hash[s[0].to_sym]=s[1]
    end
    return contents_hash
  end
  def self.generate_hash
    deals_hash={}
    deals=self.all
    deals.each do |deal|
      deals_hash[deal.name.to_sym]={}
      deals_hash[deal.name.to_sym][:quantity]=0
      deals_hash[deal.name.to_sym][:total_price]=0
      deals_hash[deal.name.to_sym][:price]=deal.price
    end
    return deals_hash
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
      self.create row.to_hash
    end
  end
  
end
