class DealOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :deal
  
  def cancelled_message
    if cancelled
      return "(Cancelled)"
    else
      return ""
    end
  end
end
