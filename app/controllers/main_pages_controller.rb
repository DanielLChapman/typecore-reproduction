class MainPagesController < ApplicationController
  before_action :logged_in_user, only: [:console]

  def home
    @art = Article.count('id')
    @num = 0
    @noFeatured = false
    @featured = 0
    if (@art != 0) 
      @num = 8
      @featured = Article.where("featured=?", "t").order('id desc').limit(8)
      if (@featured.length < 1) 
        @temp = 8
        @featured = Article.limit(@temp).order('id desc').shuffle
        if (@featured.length < @temp)
          for i in 0...8
           if (@featured[i].nil?)
             @featured[i] = @featured[0]
           end
          end
        end
        if (@featured[0].nil?)
          @num = 0
        end
      else if (@featured.length < 8)
        @temp = 8
        for i in @featured.length..(@temp-1)
         @featured[i] = @featured[0]
        end
      end
      end
    else 
      @noFeatured = true
    end
    
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
