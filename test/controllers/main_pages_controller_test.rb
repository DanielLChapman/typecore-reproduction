require 'test_helper'

class MainPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home"
  end

  test "should get author" do
    get :author
    assert_response :success
    assert_select "title", "Author"
  end

  test "should get article" do
    get :article
    assert_response :success
    assert_select "title", "Article"
  end

end
