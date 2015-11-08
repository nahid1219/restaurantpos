class OrdersController < ApplicationController
  #Display all orders
  def index
      @orders=Order.todays_orders
      @total=Order.sum_todays_orders
  end
  #Create New Order 
  def new
      if Detail.first.today_date==nil
        render action: 'message'
        return
      end
      orders=Order.todays_orders
      @orders_sitin=[]
      @orders_takeaway=[]
      orders=orders.to_a
      (0..orders.size-1).each do |i|
        if orders[i].table_id==nil
          @orders_takeaway<<orders[i]
        else
          @orders_sitin<<orders[i]
        end
      end
      @total=Order.sum_todays_orders
      @language="Urdu"
      if request[:language]
        @language=request[:language]
      end
      @deals=Deal.all.to_a
      tables=Table.empty_tables
      @tables=[]
      tables.each do |table|
        @tables<<table.nmr.to_s
      end
      @meals=Meal.all.to_a
      @order=Order.new
      @categories=Meal.get_categories_in_english
  end
  # Edit order. Used when customer orders extra items or cancels items. Each time record is update
  # a new receipt will be printed.
  def edit
      if Detail.first.today_date==nil
        render action: 'message'
        return
      end
      orders=Order.todays_orders
      @orders_sitin=[]
      @orders_takeaway=[]
      orders=orders.to_a
      (0..orders.size-1).each do |i|
        if orders[i].table_id==nil
          @orders_takeaway<<orders[i]
        else
          @orders_sitin<<orders[i]
        end
      end
      @total=Order.sum_todays_orders
      @language="Urdu"
      if request[:language]
        @language=request[:language]
      end
      @order=Order.find(request[:id])
      @ordered_meals=@order.meal_orders.order created_at: :desc
      @ordered_deals=@order.deal_orders.order created_at: :desc
      tables=Table.empty_tables
      @tableno=@order.table.nmr
      @tables=[]
      tables.each do |table|
        @tables<<table.nmr.to_s
      end
      @meals=Meal.all.to_a
      @deals=Deal.all.to_a
      @categories=Meal.get_categories_in_english
  end
  #Display an Order
  def show
     @order=Order.find(request[:id])
     @current_ticket_number=nil
     @meal_orders=@order.meal_orders
     @deal_orders=@order.deal_orders
     if @meal_orders.size!=0
        max_ticket_number_meal_orders=@order.meal_orders.order(ticket_number: :desc).first.ticket_number
     end
    #deal_orders=@order.deal_orders
    # render :inline=>"<%=@deal_orders.size%>"
    # return
     if @deal_orders.size!=0
        max_ticket_number_deal_orders=@order.deal_orders.order(ticket_number: :desc).first.ticket_number
     end
    if  max_ticket_number_meal_orders==nil
      @current_ticket_number=max_ticket_number_deal_orders
    elsif max_ticket_number_deal_orders==nil
      @current_ticket_number=max_ticket_number_meal_orders
    elsif max_ticket_number_meal_orders > max_ticket_number_deal_orders || max_ticket_number_meal_orders == max_ticket_number_deal_orders
      @current_ticket_number=max_ticket_number_meal_orders 
    elsif max_ticket_number_meal_orders < max_ticket_number_deal_orders
      @current_ticket_number=max_ticket_number_deal_orders
    end
     @meal_orders=@order.meal_orders.where(ticket_number: @current_ticket_number).order(created_at: :desc)
     @deal_orders=@order.deal_orders.where(ticket_number: @current_ticket_number).order(created_at: :desc)
     
     @cancelled_meals=@order.cancelled_meals
     @cancelled_deals=@order.cancelled_deals
  end
  #Inserts a new record in orders table.
  def create
    language=params[:order][:language]
    order_params=params[:order]
    meal_params=order_params[:meal]
    order_type_params=order_params[:order_type]
    table=nil
    @order=nil
    if order_type_params[:meal_type]=="true"
      @order=Order.new :receiptno=> Order.generate_receipt,:total=> 0,:category=>order_type_params[:meal_type],:status=>false,:cash_received=>true,:work_date=>Detail.first.today_date.to_date.to_s
    else
      table_params=order_params[:table]
      table=Table.find_by nmr: table_params[:tableno].to_i
      @order=Order.new :receiptno=> Order.generate_receipt,:total=> 0,:table=>table,:category=>order_type_params[:meal_type],:cash_received=>false,:work_date=>Detail.first.today_date.to_date.to_s  
    end
    meal_params.each do |meal_sym,value|
        m=Meal.find_by name_english: value[:name]
        if m
          count=value[:quantity].to_i
          if value[:category]=="half"
            @order.meal_orders.new :meal=>m, :quantity=>count,:category=>"half",:ticket_number=>1
            @order.total=@order.total+(count*m.price_half)
          else
            @order.meal_orders.new :meal=>m, :quantity=>count,:ticket_number=>1 
            @order.total=@order.total+(count*m.price_full) 
          end
        else
          m=Deal.find_by name: value[:name]
          count=value[:quantity].to_i
          @order.deal_orders.new :deal=>m, :quantity=>count,:ticket_number=>1
          @order.total=@order.total+(count*m.price)
        end
    end
    if @order.save
      if table!=nil
        table.update taken: true
        redirect_to order_path(@order,:print=>"ticket")
      else
        redirect_to order_bill_path(:id=>@order.id) 
      end
    else
      tables=Table.empty_tables
      @tableno=@order.table.nmr
      @tables=[]
      tables.each do |t|
        @tables<<t.nmr.to_s
      end
      @meals=Meal.all
      render 'new'
    end
  end
  #Inserts edits into join table
  def update
    @order=Order.find(params[:id])
    max_ticket_number_meal_orders=nil
    max_ticket_number_deal_orders=nil
    # shift to model after testing
    if @order.meal_orders.size!=0
        max_ticket_number_meal_orders=@order.meal_orders.order(ticket_number: :desc).first.ticket_number
     end
    if @order.deal_orders.size!=0
        max_ticket_number_deal_orders=@order.deal_orders.order(ticket_number: :desc).first.ticket_number
     end
    current_ticket_number=nil
    #max_ticket_number_meal_orders=@order.meal_orders.order(ticket_number: :desc).first.ticket_number
    #deal_orders=@order.deal_orders
    #max_ticket_number_deal_orders=@order.deal_orders.order(ticket_number: :desc).first.ticket_number
    if  max_ticket_number_meal_orders==nil
      current_ticket_number=max_ticket_number_deal_orders
    elsif max_ticket_number_deal_orders==nil
      current_ticket_number=max_ticket_number_meal_orders
    elsif max_ticket_number_meal_orders > max_ticket_number_deal_orders || max_ticket_number_meal_orders == max_ticket_number_deal_orders
      current_ticket_number=max_ticket_number_meal_orders 
    elsif max_ticket_number_meal_orders < max_ticket_number_deal_orders
      current_ticket_number=max_ticket_number_deal_orders
    end
    #==============
    if params[:order][:meal]
      order_params=params[:order]
      meal_params=order_params[:meal]
      meal_params.each do |meal_sym,value|
        m=Meal.find_by name_english: value[:name]
        if m
          count=value[:quantity].to_i
          if value[:category]=="half"
            @order.meal_orders.new :meal=>m, :quantity=>count,:category=>"half",:ticket_number=>current_ticket_number+1
            @order.total=@order.total+(count*m.price_half)
          else
            @order.meal_orders.new :meal=>m, :quantity=>count,:ticket_number=>current_ticket_number+1 
            @order.total=@order.total+(count*m.price_full) 
          end
        else
          m=Deal.find_by name: value[:name]
          count=value[:quantity].to_i
          @order.deal_orders.new :deal=>m, :quantity=>count,:ticket_number=>current_ticket_number+1
          @order.total=@order.total+(count*m.price)
        end
      end
    end
    if @order.save
      redirect_to order_path(@order,:print=>"ticket")
    else
      @ordered_meals=@order.meals
      @tableno=@order.table.nmr
      @meals=Meal.all
      render 'edit'
    end  
  end
  #Close order
  def close
    @detail=Detail.first
    @order=Order.find(request[:id])
    @total=@order.total.to_s
     @order.remove_cancelled_items
    if @order.close?
      @bill=@order.compile
    else
    # Handle Any Exception
    end
  end
  def bill
    @detail=Detail.first
    @order=Order.find(request[:id])
    @order.remove_cancelled_items
    @total=@order.total.to_s
    @bill=@order.compile
  end
  def destroy
    if request[:mealid]
      meal_order=MealOrder.find_by(order_id: request[:id],meal_id: request[:mealid]) 
      @order=Order.find(request[:id])
      @order.total=@order.total-(meal_order.quantity*meal_order.get_meal_price)
      if @order.save
        meal_order.cancelled=true
        meal_order.save
        redirect_to edit_order_path(@order)
      end
    else
      meal_order=DealOrder.find_by(order_id: request[:id],deal_id: request[:dealid]) 
      @order=Order.find(request[:id])
      @order.total=@order.total-(meal_order.quantity*meal_order.deal.price)
      if @order.save
        meal_order.cancelled=true
        meal_order.save
        redirect_to edit_order_path(@order)
      end
    end
  end 
  
  def close_store
    if Order.find_by(cash_received:false)
      redirect_to new_order_path
      return
    end
   Order.daily_breakdown
    Table.update_all taken: false
    detail=Detail.first
    detail.today_date=nil
     detail.save
    `pdbackup.bat`
    redirect_to new_order_path
  end
  
  def cash
    @order=Order.find(request[:id])
  end
  
  def receive_cash
    render :text=>params
    return 
  end
   
end
