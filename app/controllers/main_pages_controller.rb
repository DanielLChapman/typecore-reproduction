class MainPagesController < ApplicationController
  before_action :logged_in_user, only: [:console]

  def home
  end

  def author
  end

  def article
    @impess = params[:query]
    if(!Article.exists?(@impess) ) 
      @impess = Article.last.id
      @article_items = Article.where("id=?", @impess)
      impressionist(@article_items[0], @impess)
    else 
      @article_items = Article.where("id = ?", @impess)
      impressionist(@article_items[0], @impess)
    end
    
    #current_art
    @current_art = Article.all
    
    #most viewed
    @art = @current_art
    @imp = Impression.all
    @i = 1
    @a = Array.new
    @a[0] = [0,0]
    if (@art != 0)
      @num = 5
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
      @num = 0
    end
    
    #related_items
    @artcat = @article_items[0].category
    @related_items = Article.where("category = ?", @artcat).shuffle
    if (@related_items.length <= 2) 
      case @related_items.length # a_variable is the variable we want to compare
      when 0   #compare to 1
        @related_items[0] = @article_items[0]; 
        @related_items[1] = @article_items[0]; 
        @related_items[2] = @article_items[0]; 
      when 1    #compare to 2
        @related_items[1] = @article_items[0]; 
        @related_items[2] = @article_items[0]; 
      when 2   #compare to 2
        @related_items[2] = @article_items[0]; 
      else
        puts "huh?"
      end
    end
  end
  
  def console
    @article = current_user.articles.build if logged_in?
  end
  
  
  private 
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
