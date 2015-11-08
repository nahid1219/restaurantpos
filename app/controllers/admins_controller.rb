class AdminsController < ApplicationController
  def index
    if session.has_key? :user_id
     @detail=Detail.first
    else
      redirect_to sign_in_path
    end
  end
end
