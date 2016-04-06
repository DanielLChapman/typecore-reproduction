class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_filter :get_current_art
  before_filter :get_most_art

  def get_current_art
    @current_art = Article.limit(5).order('id desc')
  end
  
  def get_most_art
    @all_articles = Article.all
    @b = Impression.all
    @array_most_indice_sort = Array.new
    @array_most_indice_sort[0] = [0,0]
    @count = 0
    @most_num = 0
    @hot_article_array = Array.new
    if (@all_articles.length != 0)
      if (@all_articles.length > 5) 
        @most_num = 5
      else
        @most_num = @all_articles.length
      end
      for i in 1..(@all_articles.last.id)
        @all_articles.each do |p|
          if (p.id == i)
            @count = 0
            @b.each do |q|
              if (q.message == i.to_s)
                @count+=1
              end
            end
           @array_most_indice_sort.push([p.id,@count])
          end
        end
      end
    @array_most_indice_sort = @array_most_indice_sort.sort_by {|a,b| b}.reverse
    @array_most_indice_sort.each do |z|
      @all_articles.each do |e|
        if (z[0] == e.id)
          @hot_article_array.push(e)
        end
      end
    end
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
