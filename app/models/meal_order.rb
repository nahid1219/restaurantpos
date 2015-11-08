class MealOrder < ActiveRecord::Base
   belongs_to :order
   belongs_to :meal
   
   # def category_in_urdu
     # o=Object.new
     # if category=="half"
       # o.cat="ھاف"
       # return o
     # else
       # o.cat="فل"
       # return o
     # end
   # end
   
   def get_meal_price
     if category=="half"
       return self.meal.price_half
     else
       return self.meal.price_full
     end
   end
   
   def get_category
     m=self.meal
     if m.price_half==nil
       return "-"
     else
       return category
     end
   end
   
   def get_category_for_ticket
     m=self.meal
     if m.price_half==nil
       return ""
     else
       return "("+category+")"
     end
   end
   
   def cancelled_message
    if cancelled
      return "(Cancelled)"
    else
      return ""
    end
   end
   
   
end
