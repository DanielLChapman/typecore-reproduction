class UsersController < ApplicationController
  before_action :logged_in_user, only: [:destroy]
  before_action :admin_user,     only: [:destroy, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to '/console'
      
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:error] = "User updated"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
    end
    redirect_to '/console'
  end
  
  def admin
    if (!params[:id].nil?)
      @tempArticle = User.where("id=?", params[:id])
      if (@tempArticle[0].admin?)
        @tempArticle[0].admin = false
      else
        @tempArticle[0].admin = true
      end
      @tempArticle[0].save
      flash[:error] = "User admin toggled"
      redirect_to '/console'
    else
      redirect_to root_url
    end
  end
  
  def author
    if (!params[:id].nil?)
      @tempArticle = User.where("id=?", params[:id])
      if (@tempArticle[0].author?)
        @tempArticle[0].author = false
      else
        @tempArticle[0].author = true
      end
      @tempArticle[0].save
      flash[:error] = "User author toggled"
      redirect_to '/console'
    else
      redirect_to root_url
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private 
    def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation, :description, :admin)
    end
    def logged_in_user
        unless logged_in?
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
    end
    
    def admin_user
        redirect_to(login_path) unless current_user.admin?
    end
    
    def author_user
        redirect_to(login_path) unless current_user.author?
    end
end
