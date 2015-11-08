class ReceivingsController < ApplicationController
  def new
    @order=Order.find(request[:id])
  end
  
  def create
    @order=Order.find(params[:id].to_i)
    @order.amount_received=params[:cash][:amount].to_i
    @order.change=params[:cash][:change].to_i
    @order.cash_received=true
    @order.save
    redirect_to new_order_path
  end
end
