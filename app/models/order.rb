class Order < ActiveRecord::Base
  
  # Category True for take away false for sit in
  belongs_to :table
  has_many :meal_orders
  has_many :meals,:through=>:meal_orders
  has_many :deal_orders
  has_many :deals,:through=>:deal_orders
  
  def self.from_to_report(from,to)
    orders=self.all.where "work_date <= ? AND work_date >= ? AND store_closed=?",to.to_s,from.to_s,true
    report={}
    #detail=Detail.first
    meals_hash_takeaway=Meal.generate_hash
    meals_hash_sitin=Meal.generate_hash
    deals_hash_takeaway=Deal.generate_hash
    deals_hash_sitin=Deal.generate_hash
    orders_takeaway=self.where("store_closed=? AND category=?",true,true)
    orders_sitin=self.where("store_closed=? AND category=?",true,false)
    total_amount_takeaway=0
    orders_takeaway.each do |order|
      total_amount_takeaway=order.total+total_amount_takeaway
    end
    report[:total_takeaway]=total_amount_takeaway
    orders_takeaway.each do |order|
      meal_orders=order.meal_orders
      deal_orders=order.deal_orders
      count=0
      meal_orders.each do |meal_order|
        meal=meal_order.meal
        meal_name=meal.name_english
        meal_price=nil
        if meal_order.category=="half"
          meal_price=meal.price_half
          meals_hash_takeaway[meal_name.to_sym][:quantity][:half]=meals_hash_takeaway[meal_name.to_sym][:quantity][:half]+meal_order.quantity
        else
          meal_price=meal.price_full
          meals_hash_takeaway[meal_name.to_sym][:quantity][:full]=meals_hash_takeaway[meal_name.to_sym][:quantity][:full]+meal_order.quantity
        end
        
        meals_hash_takeaway[meal_name.to_sym][:total_price]=meals_hash_takeaway[meal_name.to_sym][:total_price]+(meal_order.quantity*meal_price)
      end
      deal_orders.each do |deal_order|
        deal=deal_order.deal
        deal_name=deal.name
        deal_price=deal.price
        deals_hash_takeaway[deal_name.to_sym][:quantity]=deals_hash_takeaway[deal_name.to_sym][:quantity]+deal_order.quantity
        deals_hash_takeaway[deal_name.to_sym][:total_price]=deals_hash_takeaway[deal_name.to_sym][:total_price]+(deal_order.quantity*deal_price)
      end
    end
    total_amount_sitin=0
    orders_sitin.each do |order|
      total_amount_sitin=order.total+total_amount_sitin
    end
    report[:total_sitin]=total_amount_sitin
    orders_sitin.each do |order|
      meal_orders=order.meal_orders
      deal_orders=order.deal_orders
      count=0
      meal_orders.each do |meal_order|
        meal=meal_order.meal
        meal_name=meal.name_english
        meal_price=nil
        if meal_order.category=="half"
          meal_price=meal.price_half
          meals_hash_sitin[meal_name.to_sym][:quantity][:half]=meals_hash_sitin[meal_name.to_sym][:quantity][:half]+meal_order.quantity
        else
          meal_price=meal.price_full
          meals_hash_sitin[meal_name.to_sym][:quantity][:full]=meals_hash_sitin[meal_name.to_sym][:quantity][:full]+meal_order.quantity
        end
        
        meals_hash_sitin[meal_name.to_sym][:total_price]=meals_hash_sitin[meal_name.to_sym][:total_price]+(meal_order.quantity*meal_price)
      end
      deal_orders.each do |deal_order|
        deal=deal_order.deal
        deal_name=deal.name
        deal_price=deal.price
        deals_hash_sitin[deal_name.to_sym][:quantity]=deals_hash_sitin[deal_name.to_sym][:quantity]+deal_order.quantity
        deals_hash_sitin[deal_name.to_sym][:total_price]=deals_hash_sitin[deal_name.to_sym][:total_price]+(deal_order.quantity*deal_price)
      end
    end
    report[:breakdown_meals_takeaway]=meals_hash_takeaway
    report[:breakdown_deals_takeaway]=deals_hash_takeaway
     report[:breakdown_meals_sitin]=meals_hash_sitin
    report[:breakdown_deals_sitin]=deals_hash_sitin
    package=Axlsx::Package.new
    workbook=package.workbook
    heading=nil
    workbook.styles do |s|
      heading = s.add_style alignment: {horizontal: :center}, b: true, sz: 10, bg_color: "0066CC", fg_color: "FF"
    end
    title = workbook.styles.add_style(:bg_color => "FFFFFFFF",
                           :fg_color=>"#FF000000",
                           :border=>Axlsx::STYLE_THIN_BORDER,
                           :alignment=>{:horizontal => :center},b: true)
    info = workbook.styles.add_style(:border=>Axlsx::STYLE_THIN_BORDER,:alignment=>{:horizontal => :left})
    workbook.add_worksheet(name: (Detail.first.today_date.to_date.strftime("%d %b %Y")).to_s) do |writer|
                           
      writer.add_image(:image_src => "app/assets/images/logo.png", :end_at => true) do |image|
        image.width=5
        image.height=90
        image.start_at 1, 1
        image.end_at 1, 7
      end
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [" ","Report "+from.strftime("%Y %b %d")+" to "+to.strftime("%Y %b %d")]
      writer.row_style 7, heading, col_offset: 1
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row ["Takeaway"],style: heading
      writer.add_row [""]
      writer.add_row ["Meals"],style: heading
      writer.add_row [""]
      writer.add_row ["Name","Quantity (full)","Rate (full)","Quantity(half)","Rate (half)","Total"],:style=>title
      report[:breakdown_meals_takeaway].each do |k,v|
        writer.add_row [k.to_s,v[:quantity][:full].to_s,v[:rate][:full].to_s,v[:quantity][:half].to_s,v[:rate][:half].to_s,v[:total_price].to_s+".00"],:style=>info
      end
      writer.add_row [""]
      writer.add_row ["Deals"],style: heading
      writer.add_row [""]
     writer.add_row ["Name","Quantity","Rate","Total"],:style=>title
      report[:breakdown_deals_takeaway].each do |k,v|
       writer.add_row [k.to_s,v[:quantity].to_s,v[:price].to_s,v[:total_price].to_s+".00"],:style=>info
      end
       writer.add_row [""]
      writer.add_row ["Total:","Rs. "+report[:total_takeaway].to_s+".00"],style: heading
      writer.add_row [""]

     writer.add_row ["Sitin"],style: heading
      writer.add_row [""]
      writer.add_row ["Meals"],style: heading
      writer.add_row [""]
      writer.add_row ["Name","Quantity (full)","Rate (full)","Quantity(half)","Rate (half)","Total"],:style=>title
      report[:breakdown_meals_sitin].each do |k,v|
        writer.add_row [k.to_s,v[:quantity][:full].to_s,v[:rate][:full].to_s,v[:quantity][:half].to_s,v[:rate][:half].to_s,v[:total_price].to_s+".00"],:style=>info
      end
      writer.add_row [""]
      writer.add_row ["Deals"],style: heading
      writer.add_row [""]
     writer.add_row ["Name","Quantity","Rate","Total"],:style=>title
      report[:breakdown_deals_sitin].each do |k,v|
       writer.add_row [k.to_s,v[:quantity].to_s,v[:price].to_s,v[:total_price].to_s+".00"],:style=>info
      end
       writer.add_row [""]
      writer.add_row ["Total:","Rs. "+report[:total_sitin].to_s+".00"],style: heading
      writer.add_row [""]
       writer.add_row [""]
      writer.add_row ["Total Number of Orders",(orders_takeaway.size+orders_sitin.size).to_s],style: heading
      writer.add_row ["Total Income in Rs",(report[:total_sitin]+report[:total_takeaway]).to_s+".00"], style: heading  
    end
    package.serialize "data/"+from.strftime("%Y %b %d")+" to "+to.strftime("%Y %b %d")+".xlsx"
    return "data/"+from.strftime("%Y %b %d")+" to "+to.strftime("%Y %b %d")+".xlsx"
  end
  
  def self.daily_breakdown
    detail=Detail.first
    previous_reports=Report.all
    if previous_reports.size!=0
      previous_reports.each do |previous_report|
        file_path=previous_report.file_path
        file_date=previous_report.file_date
        ReportMailer.send_previous_report(detail.email,file_date,detail.name).deliver
        File.delete(file_path)
      end
      Report.delete_all
    end
    report={}
    meals_hash_takeaway=Meal.generate_hash
    meals_hash_sitin=Meal.generate_hash
    deals_hash_takeaway=Deal.generate_hash
    deals_hash_sitin=Deal.generate_hash
    orders_takeaway=self.where("store_closed=? AND category=?",false,true)
    orders_sitin=self.where("store_closed=? AND category=?",false,false)
    total_amount_takeaway=0
    orders_takeaway.each do |order|
      total_amount_takeaway=order.total+total_amount_takeaway
    end
    report[:total_takeaway]=total_amount_takeaway
    orders_takeaway.each do |order|
      meal_orders=order.meal_orders
      deal_orders=order.deal_orders
      count=0
      meal_orders.each do |meal_order|
        meal=meal_order.meal
        meal_name=meal.name_english
        meal_price=nil
        if meal_order.category=="half"
          meal_price=meal.price_half
          meals_hash_takeaway[meal_name.to_sym][:quantity][:half]=meals_hash_takeaway[meal_name.to_sym][:quantity][:half]+meal_order.quantity
        else
          meal_price=meal.price_full
          meals_hash_takeaway[meal_name.to_sym][:quantity][:full]=meals_hash_takeaway[meal_name.to_sym][:quantity][:full]+meal_order.quantity
        end
        
        meals_hash_takeaway[meal_name.to_sym][:total_price]=meals_hash_takeaway[meal_name.to_sym][:total_price]+(meal_order.quantity*meal_price)
      end
      deal_orders.each do |deal_order|
        deal=deal_order.deal
        deal_name=deal.name
        deal_price=deal.price
        deals_hash_takeaway[deal_name.to_sym][:quantity]=deals_hash_takeaway[deal_name.to_sym][:quantity]+deal_order.quantity
        deals_hash_takeaway[deal_name.to_sym][:total_price]=deals_hash_takeaway[deal_name.to_sym][:total_price]+(deal_order.quantity*deal_price)
      end
     order.store_closed=true
     order.save
    end
    total_amount_sitin=0
    orders_sitin.each do |order|
      total_amount_sitin=order.total+total_amount_sitin
    end
    report[:total_sitin]=total_amount_sitin
    orders_sitin.each do |order|
      meal_orders=order.meal_orders
      deal_orders=order.deal_orders
      count=0
      meal_orders.each do |meal_order|
        meal=meal_order.meal
        meal_name=meal.name_english
        meal_price=nil
        if meal_order.category=="half"
          meal_price=meal.price_half
          meals_hash_sitin[meal_name.to_sym][:quantity][:half]=meals_hash_sitin[meal_name.to_sym][:quantity][:half]+meal_order.quantity
        else
          meal_price=meal.price_full
          meals_hash_sitin[meal_name.to_sym][:quantity][:full]=meals_hash_sitin[meal_name.to_sym][:quantity][:full]+meal_order.quantity
        end
        
        meals_hash_sitin[meal_name.to_sym][:total_price]=meals_hash_sitin[meal_name.to_sym][:total_price]+(meal_order.quantity*meal_price)
      end
      deal_orders.each do |deal_order|
        deal=deal_order.deal
        deal_name=deal.name
        deal_price=deal.price
        deals_hash_sitin[deal_name.to_sym][:quantity]=deals_hash_sitin[deal_name.to_sym][:quantity]+deal_order.quantity
        deals_hash_sitin[deal_name.to_sym][:total_price]=deals_hash_sitin[deal_name.to_sym][:total_price]+(deal_order.quantity*deal_price)
      end
     order.store_closed=true
     order.save
    end
    report[:breakdown_meals_takeaway]=meals_hash_takeaway
    report[:breakdown_deals_takeaway]=deals_hash_takeaway
     report[:breakdown_meals_sitin]=meals_hash_sitin
    report[:breakdown_deals_sitin]=deals_hash_sitin
    package=Axlsx::Package.new
    workbook=package.workbook
    heading=nil
    workbook.styles do |s|
      heading = s.add_style alignment: {horizontal: :center}, b: true, sz: 10, bg_color: "0066CC", fg_color: "FF"
    end
    title = workbook.styles.add_style(:bg_color => "FFFFFFFF",
                           :fg_color=>"#FF000000",
                           :border=>Axlsx::STYLE_THIN_BORDER,
                           :alignment=>{:horizontal => :center},b: true)
    info = workbook.styles.add_style(:border=>Axlsx::STYLE_THIN_BORDER,:alignment=>{:horizontal => :left})
    workbook.add_worksheet(name: (Detail.first.today_date.to_date.strftime("%d %b %Y")).to_s) do |writer|
                           
      writer.add_image(:image_src => "app/assets/images/logo.png", :end_at => true) do |image|
        image.width=5
        image.height=90
        image.start_at 1, 1
        image.end_at 1, 7
      end
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row [" ","Report Dated "+detail.today_date.to_date.strftime("%d %b %Y")],style: heading
      writer.row_style 7, heading, col_offset: 1
      writer.add_row [""]
      writer.add_row [""]
      writer.add_row ["Takeaway"],style: heading
      writer.add_row [""]
      writer.add_row ["Meals"],style: heading
      writer.add_row [""]
      writer.add_row ["Name","Quantity (full)","Rate (full)","Quantity(half)","Rate (half)","Total"],:style=>title
      report[:breakdown_meals_takeaway].each do |k,v|
        writer.add_row [k.to_s,v[:quantity][:full].to_s,v[:rate][:full].to_s,v[:quantity][:half].to_s,v[:rate][:half].to_s,v[:total_price].to_s+".00"],:style=>info
      end
      writer.add_row [""]
      writer.add_row ["Deals"],style: heading
      writer.add_row [""]
     writer.add_row ["Name","Quantity","Rate","Total"],:style=>title
      report[:breakdown_deals_takeaway].each do |k,v|
       writer.add_row [k.to_s,v[:quantity].to_s,v[:price].to_s,v[:total_price].to_s+".00"],:style=>info
      end
       writer.add_row [""]
      writer.add_row ["Total:","Rs. "+report[:total_takeaway].to_s+".00"],style: heading
      writer.add_row [""]

     writer.add_row ["Sitin"],style: heading
      writer.add_row [""]
      writer.add_row ["Meals"],style: heading
      writer.add_row [""]
      writer.add_row ["Name","Quantity (full)","Rate (full)","Quantity(half)","Rate (half)","Total"],:style=>title
      report[:breakdown_meals_sitin].each do |k,v|
        writer.add_row [k.to_s,v[:quantity][:full].to_s,v[:rate][:full].to_s,v[:quantity][:half].to_s,v[:rate][:half].to_s,v[:total_price].to_s+".00"],:style=>info
      end
      writer.add_row [""]
      writer.add_row ["Deals"],style: heading
      writer.add_row [""]
     writer.add_row ["Name","Quantity","Rate","Total"],:style=>title
      report[:breakdown_deals_sitin].each do |k,v|
       writer.add_row [k.to_s,v[:quantity].to_s,v[:price].to_s,v[:total_price].to_s+".00"],:style=>info
      end
       writer.add_row [""]
      writer.add_row ["Total:","Rs. "+report[:total_sitin].to_s+".00"],style: heading
      writer.add_row [""]
       writer.add_row [""]
      writer.add_row ["Total Number of Orders",(orders_takeaway.size+orders_sitin.size).to_s],style: heading
      writer.add_row ["Total Income in Rs",(report[:total_sitin]+report[:total_takeaway]).to_s+".00"], style: heading  
    end
    package.serialize "data/"+(detail.today_date.to_date).to_s+".xlsx"
    
      begin
       ReportMailer.send_report(detail.email,detail.today_date.to_date.to_s,detail.name).deliver
       File.delete("data/"+(detail.today_date.to_date).to_s+".xlsx")
      rescue
        file_date=detail.today_date.to_date.to_s
        file_path="reports/"+(detail.today_date.to_date).to_s+".xlsx"
        Report.create(file_date: file_date, file_path: file_path)
        FileUtils.mv("data/"+(detail.today_date.to_date).to_s+".xlsx","reports/")
        
      end
  end
  
  def self.todays_orders
    orders=self.where store_closed: false
    return orders.order(receiptno: :desc)
  end
  
  def self.todays_takeaway_orders
    orders=self.where store_closed: false
    return orders
  end
  
  def self.todays_sitin_orders
    orders=self.where "table_id >= 1",store_closed:false
    return orders
  end
  
  def is_takeaway
    if category
      return true
    else
      return false
    end
  end

  def self.sum_todays_orders
    total_value=0;
    orders=self.where store_closed: false
    orders.each do |order|
        total_value=total_value+order.total
    end
    return total_value
  end
  
  def current_status
    if status
      return "Open"
    else
      return "Closed"
    end
  end
  
  def compile
    meal_orders=self.meal_orders
    deal_orders=self.deal_orders
    items={}
    count=0
    meal_orders.each do |meal_order|
      if count==1
          if items.has_key?(meal_order.meal.name_english.to_sym)
            items[meal_order.meal.name_english.to_sym][:total]=items[meal_order.meal.name_english.to_sym][:total]+meal_order.quantity*meal_order.get_meal_price
            items[meal_order.meal.name_english.to_sym][:quantity]=items[meal_order.meal.name_english.to_sym][:quantity]+meal_order.quantity
          else
            items[meal_order.meal.name_english.to_sym]={}
            items[meal_order.meal.name_english.to_sym][:quantity]=meal_order.quantity
            items[meal_order.meal.name_english.to_sym][:category]=meal_order.get_category
            items[meal_order.meal.name_english.to_sym][:rate]=meal_order.get_meal_price
            items[meal_order.meal.name_english.to_sym][:total]=meal_order.quantity*meal_order.get_meal_price
          end
      else
          items[meal_order.meal.name_english.to_sym]={}
          items[meal_order.meal.name_english.to_sym][:quantity]=meal_order.quantity
          items[meal_order.meal.name_english.to_sym][:category]=meal_order.get_category
          items[meal_order.meal.name_english.to_sym][:rate]=meal_order.get_meal_price
          items[meal_order.meal.name_english.to_sym][:total]=meal_order.quantity*meal_order.get_meal_price
          count=1
      end
    end
    count=0
    deal_orders.each do |deal_order|
      if count==1
          if items.has_key?(deal_order.deal.name.to_sym)
            items[deal_order.deal.name.to_sym][:total]=items[deal_order.deal.name.to_sym][:total]+deal_order.quantity*deal_order.deal.price
          else
            items[deal_order.deal.name.to_sym]={}
            items[deal_order.deal.name.to_sym][:quantity]=deal_order.quantity
            items[deal_order.deal.name.to_sym][:rate]=deal_order.deal.price
            items[deal_order.deal.name.to_sym][:total]=deal_order.quantity*deal_order.deal.price
          end
      else
          items[deal_order.deal.name.to_sym]={}
          items[deal_order.deal.name.to_sym][:quantity]=deal_order.quantity
          items[deal_order.deal.name.to_sym][:rate]=deal_order.deal.price
          items[deal_order.deal.name.to_sym][:total]=deal_order.quantity*deal_order.deal.price
          count=1
      end
    end
    return items
  end
  
  def close?
    self.status=false
    if self.save
      self.table.update taken: false
      return true
    else
      return false
    end
  end
  
  def self.generate_receipt
    receipt=""
    time_now_components=Time.now.to_s.split(" ")
    date_now=time_now_components[0].split("-")
    time_now=time_now_components[1].split(":")
    date_now.each do |date_part|
      receipt<<date_part+"/"
    end
    time_now.each do |time_part|
      receipt<<time_part
    end
    return receipt
  end
  
  def cash_received?
    if cash_received
      return true
    else
      return false  
    end  
  end
  
  def remove_cancelled_items
    self.meal_orders.where(cancelled: true).delete_all
    self.deal_orders.where(cancelled: true).delete_all
  end
  
  def cancelled_meals
    self.meal_orders.where(cancelled: true).order created_at: :desc
  end
  
  def cancelled_deals
    self.deal_orders.where(cancelled: true).order created_at: :desc
  end
  
end
