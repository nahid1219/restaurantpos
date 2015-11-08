# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#,
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# encoding: UTF-8

u=User.new(user_name:"user",password:"user",password_confirmation:"user",admin:"true");
u.save

detail=Detail.create name: "Paris Dhaba",city: "Gujrat",phone1: "0533-601292",phone2: "0533-601292",address: "Opp. Church, Near Katchery, Bhimber Road",email: "parisdhabareports@gmail.com",today_date: Time.now.to_date

if Meal.all.count!=0
  Meal.delete_all
end

if Table.all.count!=0
  Table.delete_all
end

# Table.create([{nmr: 1, seats:4},
              # {nmr: 2, seats:4},
              # {nmr: 3, seats:4},
              # {nmr: 4, seats:4},
              # {nmr: 5, seats:4},
              # {nmr: 6, seats:4}]);
Table.import("tables.xlsx")              
Meal.import("meals1.xlsx")
Deal.import("deals.xls")
              
# workbook=Roo::Excelx.new('meals.xlsx')      
# 
# workbook.default_sheet = workbook.sheets[0]
# 
# headers = Hash.new
# workbook.row(0).each_with_index {|header,i|
# headers[header] = i
# }
# 
# ((workbook.first_row+1)..workbook.last_row).each do |row|
  # puts workbook.row(row)[headers[:name_english]]
  # name_english=workbook.row(row)[headers[:name_english]].to_s
  # name_urdu=workbook.row(row)[headers[:name_urdu]].to_s
  # price=workbook.row(row)[headers[:price]].to_i
  # Meal.create name_english: name_english, name_urdu: name_urdu, price: price
# end     

# spreadsheet = open_spreadsheet("meals.xlsx")
  # header = spreadsheet.row(1)
  # (2..spreadsheet.last_row).each do |i|
    # row = Hash[[header, spreadsheet.row(i)].transpose]
    # meal = Meal.find_by_id(row["id"]) || Meal.new
    # meal.attributes = row.to_hash.slice(*accessible_attributes)
    # meal.save!
  # end   

 # Meal.create([{name_english: "Tea",price: 5},
              # {name_english: "Cholai",price: 15},
              # {name_english: "Roti",price: 3},
              # {name_english: "Aloo Paratha",price: 10},
              # {name_english: "Paneer Paratha",price: 15},
              # {name_english: "Pakorai",price: 30},
              # {name_english: "Samosa",price: 5},
              # {name_english: "Roll",price: 20},
              # {name_english: "Soup",price: 15},
              # {name_english: "Raita",price: 15}
            # ]);
            
            
            
            

