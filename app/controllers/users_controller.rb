class UsersController < ApplicationController
  
  def index
    if !session.has_key? :user_id 
        redirect_to sign_in_path
        return
    end
    @user = User.new
    @detail=Detail.first
    @users=User.all
  end
  
  def new
     if !session.has_key? :user_id 
        redirect_to sign_in_path
        return
    end
    @user = User.new
  end
  
  def edit
     if !session.has_key? :user_id 
        redirect_to sign_in_path
        return
    end
   if !session.has_key? :user_id 
        redirect_to sign_in_path
        return
    end
    @user = User.find(request[:id])
    @detail=Detail.first
    @users=User.all
    render action: 'index'
  end
  
  def update
    @user = User.find(params[:id])
    if @user.user_name!=user_params[:user_name]
      @user.user_name=user_params[:user_name]
    end
    if @user.first_name!=user_params[:first_name]
      @user.user_name=user_params[:first_name]
    end
    if @user.last_name!=user_params[:last_name]
      @user.user_name=user_params[:first_name]
    end
    if user_params[:password]!=nil
      @user.password=user_params[:password]
    end
    if user_params[:password_confirmation]!=nil
      @user.password_confirmation=user_params[:password_confirmation]
    end
    @detail=Detail.first
    @users=User.all
    if @user.save
      redirect_to users_path, :notice => "User Updated!!"
    else
      render "index"
    end
  end

  def create
    @user = User.new(user_params)
    @user.admin=true
    @users=User.all
    @detail=Detail.first
    if @user.save
      redirect_to users_path, :notice => "User Created!!"
    else
      render "index"
    end
  end
  
  def destroy
     User.delete(request[:id])
     redirect_to users_path, :notice => "User Deleted!!"
  end
  
  def user_params
    params.require(:user).permit :password,:password_confirmation,:user_name,:first_name,:last_name
  end
end
