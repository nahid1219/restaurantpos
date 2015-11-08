class MealsController < ApplicationController
  layout  'admins'
  respond_to :js
  def index
    if session.has_key? :user_id 
      @meals=Meal.all.order(category_number: :asc).to_a
      @categories=Meal.get_categories_in_english
      @deals=Deal.all.order(deal_no: :asc).to_a
      @detail=Detail.first
   else
     redirect_to sign_in_path
     return
   end
  end 
  
  def new
    @meal=Meal.new
    @categories_english=Meal.get_categories_in_english
    @categories_urdu=Meal.get_categories_in_urdu

    @detail=Detail.first
  end 
  
  def edit
    @meal=Meal.find(request[:id])
    @categories_english=Meal.get_categories_in_english
    @categories_urdu=Meal.get_categories_in_urdu
    @detail=Detail.first
  end
  
  def create
    @meal=Meal.new(meal_params)
    if params[:meal][:image]==nil
       render 'new'
       return
    end
    alpha_meal=Meal.find_by category_english: @meal.category_english
    if alpha_meal
      @meal.category_number=alpha_meal.category_number
    else
      @meal.category_number=Meal.order(category_number: :desc).first.category_number+1
    end    
    if @meal.save
       filepath="app/assets/images/"+@meal.name_english+".png"
       File.open(filepath,"wb") do |f|
         f.write(params[:meal][:image][:file].read);
       end
       redirect_to meals_path
    else
      render 'index'
      return
    end
  end
  
  def update
    @meal=Meal.find(params[:id])
    @meal.name_english=meal_params[:name_english]
    @meal.name_urdu=meal_params[:name_urdu]
    @meal.category_urdu=meal_params[:category_urdu]
    @meal.category_english=meal_params[:category_english]
    if meal_params[:price_half]==nil
      @meal.price_half=nil
      @meal.price_full=meal_params[:price_full]
    else
      @meal.price_half=meal_params[:price_half]
      @meal.price_full=meal_params[:price_full]
    end
    if @meal.save
      redirect_to meals_path
    else
      render 'edit'
    end
  end
  
  def destroy
    meal_name=Meal.find(request[:id]).meal_name
    Meal.delete(request[:id])
    File.delete("app/assets/images/"+meal_name+".png")
    redirect_to meals_path
  end
  
  def show
    @meal=Meal.find_by "name_english=?" , request[:name]
  end
  
  def meal_params
     params.require(:meal).permit :name_english,:name_urdu,:price_half,:price_full,:category_english,:category_urdu
  end
end
