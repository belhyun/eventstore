require 'test_helper'

class GroupProductsControllerTest < ActionController::TestCase
  setup do
    @group_product = group_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:group_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group_product" do
    assert_difference('GroupProduct.count') do
      post :create, group_product: { group_id: @group_product.group_id, product_id: @group_product.product_id }
    end

    assert_redirected_to group_product_path(assigns(:group_product))
  end

  test "should show group_product" do
    get :show, id: @group_product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @group_product
    assert_response :success
  end

  test "should update group_product" do
    patch :update, id: @group_product, group_product: { group_id: @group_product.group_id, product_id: @group_product.product_id }
    assert_redirected_to group_product_path(assigns(:group_product))
  end

  test "should destroy group_product" do
    assert_difference('GroupProduct.count', -1) do
      delete :destroy, id: @group_product
    end

    assert_redirected_to group_products_path
  end
end
