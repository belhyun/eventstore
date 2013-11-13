require 'test_helper'

class MypeopleControllerTest < ActionController::TestCase
  setup do
    @myperson = mypeople(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mypeople)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create myperson" do
    assert_difference('Myperson.count') do
      post :create, myperson: {  }
    end

    assert_redirected_to myperson_path(assigns(:myperson))
  end

  test "should show myperson" do
    get :show, id: @myperson
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @myperson
    assert_response :success
  end

  test "should update myperson" do
    patch :update, id: @myperson, myperson: {  }
    assert_redirected_to myperson_path(assigns(:myperson))
  end

  test "should destroy myperson" do
    assert_difference('Myperson.count', -1) do
      delete :destroy, id: @myperson
    end

    assert_redirected_to mypeople_path
  end
end
