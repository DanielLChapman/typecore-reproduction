class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  
  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render '/console'
    end
  end

  def destroy
  end

  private

    def article_params
      params.require(:article).permit(:body, :picture, :category, :title, :tag)
    end
end
