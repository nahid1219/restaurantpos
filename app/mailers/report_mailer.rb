class ReportMailer < ActionMailer::Base
  default from: "parisdhabareports@gmail.com"
  def send_report(email,date,restaurant_name)
    @date=date
    attachments[date.to_s+".xlsx"]=File.read("data/"+date.to_s+".xlsx",:mode => 'rb')
    if mail(to: email,subject: restaurant_name+" Earnings Report Dated "+date.to_s)
      return true
    else
      return false
    end
  end
  def send_previous_report(email,date,restaurant_name)
    @date=date
    attachments[date+".xlsx"]=File.read("reports/"+date+".xlsx",:mode => 'rb')
    if mail(to: email,subject: restaurant_name+" Earnings Report Dated "+date)
      return true
    else
      return false
    end
  end
end
