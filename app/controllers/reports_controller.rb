class ReportsController < ApplicationController
  layout 'admins'
  def index
    @meals=Meal.all
    @meal=Meal.new
    @detail=Detail.first
  end
  def create
    
    from=Date.parse(params[:from])
    to=Date.parse(params[:to])
    if to<from
      redirect_to reports_path
      return
    end
    file_path=Order.from_to_report(from,to)
    send_file file_path, :type=>"application/xlsx", :x_sendfile=>true
  end
end
