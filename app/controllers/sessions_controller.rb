class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: [:new, :create]
  
    def new 
      
    end 
  
    def create
      @user = User.find_by(email: params[:session][:email])
    
      if @user && @user.authenticate(params[:session][:password])
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else 
        flash[:error] = "Email or Password not matching"
        redirect_to new_login_path
      end 
    end 
  
    def destroy
      session[:user_id] = nil
  
      redirect_to users_path
    end 
  end