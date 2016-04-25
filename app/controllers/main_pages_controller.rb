class MainPagesController < ApplicationController
  before_action :logged_in_user, only: [:create, :console]

  def home
    @art_full = Article.all
    @art = @art_full.length
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
          @noFeatured = true
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
    @impess = params[:query]
    
    if (!Article.exists?(@impess))
      @impess = Article.last.user_id
    end
    if (!@impess.nil?)
      @art_full = Article.where("user_id=?", @impess)
    end
  end

  def article
    @comment = Comment.new
    @impess = params[:query]
    @artsize = Article.all.size
    if (@artsize != 0)
      if(!Article.exists?(@impess) ) 
        @impess = Article.last.id
      end
      @article_items = Article.where("id=?", @impess).limit(1)
      impressionist(@article_items[0], @impess)
      
      #related_items
      @artcat = @article_items[0].category
      @related_items = Article.where("category = ?", @artcat).limit(3).order("RANDOM()")
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
      
      #comments
      @a = Comment.where("article_id=?", @impess).where("parent=?", "-1")
      @comment_items = Array.new
      if (@a.exists?)
        @a.each do |p| 
          @comment_items.push(p)
          @b = Comment.where("parent=?", p.id)
          if (@b.exists?)
            @comment_items.push("child")
            @b.each do |q|
              @comment_items.push(q)
              @c = Comment.where("parent=?", q.id)
              if (@c.exists?)
                @comment_items.push("child")
                @c.each do |w| 
                  @comment_items.push(w)  
                end
                @comment_items.push("done")
              end
            end
             @comment_items.push("done")
          end
        end
         @comment_items.push("done")
        
      end
    end
    
  end
  
  
  def console
    @article = current_user.articles.build if logged_in?
    @user = User.new
    @article_list =  Article.all
    @user_list = User.all
  end
  
  def category 
     @impess = params[:query]
     
    if (!Article.where("category=?", @impess).exists?)
      @impess = Article.category
    end
    if (!@impess.nil?)
      @art_full = Article.where("category=?", @impess)
    end
  end
  
  private 
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

    def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation, :description, :admin)
    end
end
