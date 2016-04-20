class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :featured]
  before_action :author_user, only: [:featured]
  
  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = "Article created!"
      redirect_to root_url
    else
      flash[:error] = @article.errors.full_messages.to_sentence
      render '/console'
    end
  end
  
  def articleedit
    @article = Article.find(params[:id])
    if @article.update_attributes(article_params)
      redirect_to '/article?query='+params[:id]
    else
      flash[:error] = @article.errors.full_messages.to_sentence
      redirect_to '/console'
    end
  end

  def destroy
    Article.find(params[:id]).destroy
    flash[:error] = "Article deleted"
    redirect_to '/console'
  end
  
  def featured
    if (!params[:id].nil?)
      @tempArticle = Article.where("id=?", params[:id])
      if (@tempArticle[0].featured)
        @tempArticle[0].featured = false
      else
        @tempArticle[0].featured = true
      end
      @tempArticle[0].save
      flash[:error] = "Article feature toggled"
      redirect_to '/console'
    else
      redirect_to root_url
    end
  end

  private

    def article_params
      params.require(:article).permit(:body, :picture, :category, :title, :tag)
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
