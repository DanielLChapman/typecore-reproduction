require 'test_helper'

class ArticlesEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @article = articles(:one)
  end
  
  test "unsuccessful edit" do
    patch articleedit_path( :id => @article.id), article: { title: "",
  user_id: "1",
  category: "",
  body: "" }
    assert_template '/console'
  end
end
