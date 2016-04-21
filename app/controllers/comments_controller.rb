class CommentsController < ApplicationController
  
  def create 
    @current_article = Article.where("id=?", params[:id])
    @comment = @current_article[0].comments.build(comment_params)
    if @comment.save
      redirect_to '/article?query='+params[:id]+'#comment-'+@comment.id.to_s
    else
      flash[:error] = @comment.errors.full_messages.to_sentence
      redirect_to '/article?query='+params[:id]+'#comment-anchor'
    end
  end
  
  private

    def comment_params
      params.require(:comment).permit(:content, :name, :email, :website, :parent)
    end
end
