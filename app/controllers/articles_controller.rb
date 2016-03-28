class ArticlesController < ApplicationController
  
  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
end
