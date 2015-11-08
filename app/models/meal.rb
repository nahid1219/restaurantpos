# encoding: UTF-8
class Meal < ActiveRecord::Base
  has_many :meal_orders
  has_many :orders,:through=>:meal_orders
  validates_uniqueness_of :name_english
  validates_presence_of :name_english
  validates_uniqueness_of :name_urdu
  #validates_presence_of :name_urdu
  validates_presence_of :price_full
  
  def is_full?
    if name_english.include? "half"
      return false
    elsif name_english.include? "full"
      return true  
    end
  end
  
  def meal_name
    name=""
    if name_english.include?("half") || name_english.include?("Half")
      n=name_english.split(" ")
      (0..n.size-2).each do |i|
        if i==n.size-2
          name<<n[i]
        else
          name<<n[i]+" "
        end
      end
    elsif name_english.include?("full") || name_english.include?("Full")
      n=name_english.split(" ")
      (0..n.size-2).each do |i|
        if i==n.size-2
          name<<n[i]
        else
          name<<n[i]+" "
        end
      end
     else
       name=name_english  
    end
    return name
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
    num=1
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      m=self.new row.to_hash
      m.category_number=num
      m.save
      row1=nil
      if i!=spreadsheet.last_row
        row1=Hash[[header, spreadsheet.row(i+1)].transpose]
        row1=row1.to_hash
        if row1[:category_urdu]!=row[:category_urdu]
          num=num+1
        end
      end
    end
  end
  
  def self.get_categories_in_english
    m=self.order(category_number: :asc)
    return m.pluck(:category_english).uniq
  end
  
  def self.get_categories_in_urdu
      m=self.order(category_number: :asc)
     return m.pluck(:category_urdu).uniq
  end
  
  def self.generate_hash
    meals_hash={}
    meals=self.all
    meals.each do |meal|
      meals_hash[meal.name_english.to_sym]={}
      meals_hash[meal.name_english.to_sym][:quantity]={}
      meals_hash[meal.name_english.to_sym][:quantity][:half]=0
      meals_hash[meal.name_english.to_sym][:quantity][:full]=0
      meals_hash[meal.name_english.to_sym][:total_price]=0
      meals_hash[meal.name_english.to_sym][:rate]={}
      meals_hash[meal.name_english.to_sym][:rate][:full]=meal.price_full
      meals_hash[meal.name_english.to_sym][:rate][:half]=meal.price_half
    end
    return meals_hash
  end
  
  def self.create_meal(meal_params)
     if meal_params[:image]==nil
       return Meal.new
     end
     meal=self.new name_english: meal_params[:name_english],name_urdu: meal_params[:name_urdu],price: meal_params[:price]
     filepath="app/assets/images/"+meal.name_english+".png"
     if meal.save
       File.open(filepath,"wb") do |f|
         f.write(meal_params[:image][:file].read);
       end
       img=Magick::ImageList.new(filepath).first
       img.scale(100,100)
       img.write(filepath)
       return meal
     else
       return meal  
     end
  end
  
  def is_half_full?
    if price_half==nil
      return false
    else
      return true
    end
  end
  
  def label_tag
    return "label_tag "+name_english+",nil,:style=>'font-size: medium;'"
  end
  
end
