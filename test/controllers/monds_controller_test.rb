require 'test_helper'

class MondsControllerTest < ActionController::TestCase
  setup do
    @mond = monds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:monds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mond" do
    assert_difference('Mond.count') do
      post :create, mond: {  }
    end

    assert_redirected_to mond_path(assigns(:mond))
  end

  test "should show mond" do
    get :show, id: @mond
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mond
    assert_response :success
  end

  test "should update mond" do
    patch :update, id: @mond, mond: {  }
    assert_redirected_to mond_path(assigns(:mond))
  end

  test "should destroy mond" do
    assert_difference('Mond.count', -1) do
      delete :destroy, id: @mond
    end

    assert_redirected_to monds_path
  end
end
