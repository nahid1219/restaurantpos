class DetailsController < ApplicationController
  def edit
    if session.has_key? :user_id 
     if current_user.is_admin?
    @detail=Detail.find(request[:id])
     else
      redirect_to root_url
      return
     end
   else
     redirect_to sign_in_path
     return
   end
  end
  def update
    @detail=Detail.find(params[:id])
    if @detail.update detail_params
      redirect_to edit_detail_path(@detail)
    else
      render 'edit'
    end
  end
  def detail_params
    params.require(:detail).permit :name,:city,:phone1,:phone2,:address,:email
  end
end
