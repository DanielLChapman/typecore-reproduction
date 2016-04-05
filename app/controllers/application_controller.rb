class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_filter :get_current_art
  before_filter :get_most_art

  def get_current_art
    @current_art = Article.all
  end
  
  def get_most_art
    #most viewed
    @art = @current_art
    @imp = Impression.all
    @i = 1
    @a = Array.new
    @a[0] = [0,0]
    @num = 0
    if (@current_art.size != 0)
      if (@current_art.size >= 5) 
        @num = 5
      else
        @num = @current_art.size
      end
      while (@i <= @art.length)
      	@a[@i] = [@i, 0]
      	@i += 1
      end
      @i = 0
      
      while(@i < @imp.length)
      	@temp = @imp[@i].message.to_i
      	@a[@temp][1] += 1
      	@i+=1
      end
      @a = @a.sort_by {|a,b| b}.reverse
      @i = 0
    else
    end
    
  end
  
  
  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
