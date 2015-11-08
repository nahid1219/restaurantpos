class TablesController < ApplicationController
  
  layout  'admins'
  
  def index
    if session.has_key? :user_id 
      @tables=Table.all.order nmr: :asc
      @table=Table.new
      @detail=Detail.first
   else
     redirect_to sign_in_path
     return
   end
  end 
  
  def edit
    if session.has_key? :user_id 
      @tables=Table.all.order nmr: :asc
      @table=Table.find(request[:id])
      @detail=Detail.first
      render 'index'
   else
     redirect_to sign_in_path
     return
   end
  end 
  
  def create
    @table=Table.new table_params
    @tables=Table.all
    @detail=Detail.first
    if @table.save
      redirect_to tables_path
    else
      render 'index'
    end
  end
  
  def destroy
    Table.delete(request[:id])
    redirect_to tables_path
  end
  
  def table_params
     params.require(:table).permit :nmr,:seats
  end
  
end
