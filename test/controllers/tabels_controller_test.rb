require 'test_helper'

class TabelsControllerTest < ActionController::TestCase
  setup do
    @tabel = tabels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tabels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tabel" do
    assert_difference('Tabel.count') do
      post :create, time: {  }
    end

    assert_redirected_to tabel_path(assigns(:time))
  end

  test "should show tabel" do
    get :show, id: @tabel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tabel
    assert_response :success
  end

  test "should update tabel" do
    patch :update, id: @tabel, time: {  }
    assert_redirected_to tabel_path(assigns(:time))
  end

  test "should destroy tabel" do
    assert_difference('Tabel.count', -1) do
      delete :destroy, id: @tabel
    end

    assert_redirected_to tabels_path
  end
end
