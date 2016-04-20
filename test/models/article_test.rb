require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
    @article = @user.articles.build(body: "Lorem ipsum", title: "Sample Title", category: "Sample", tag: "Tag line")
  end

  test "should be valid" do
    assert @article.valid?
  end

  test "user id should be present" do
    @article.user_id = nil
    assert_not @article.valid?
  end
  
  test "body should be present" do
    @article.body = nil
    assert_not @article.valid?
  end
  test "title id should be present" do
    @article.title = nil
    assert_not @article.valid?
  end
  test "category should be present" do
    @article.category = nil
    assert_not @article.valid?
  end
end
