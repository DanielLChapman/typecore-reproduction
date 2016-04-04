class UsersController < ApplicationController
  before_action :logged_in_user, only: [:destroy]
  before_action :admin_user,     only: :destroy
  
  def new
  end
  
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private 
    def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation, :description)
    end
    def logged_in_user
        unless logged_in?
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
    end
    
    def admin_user
        redirect_to(login_path) unless current_user.author?
    end
end
