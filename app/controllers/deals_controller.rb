class DealsController < ApplicationController
  def edit
    @detail=Detail.first
    @deal=Deal.find(request[:id])
  end
  def update
    @deal=Deal.find(params[:id])
    @deal.price=deal_params[:price]
    if @deal.save
      redirect_to meals_path
    else
      render 'edit'
      return
    end
  end
  def destroy
    Deal.delete(request[:id])
    redirect_to meals_path
  end
  def deal_params
    params.require(:deal).permit :price
  end
end
