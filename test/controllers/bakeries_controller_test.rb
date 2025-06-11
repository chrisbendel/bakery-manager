require "test_helper"

class BakeriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @other_user = create(:user)
    @bakery = create(:bakery)
    @bakery.bakery_memberships.create!(user: @user, role: :owner)
  end

  test "should redirect to sign in when not authenticated" do
    get new_bakery_url
    assert_redirected_to sign_in_url

    post bakeries_url, params: {bakery: {name: Faker::Restaurant.name, description: Faker::Restaurant.description}}
    assert_redirected_to sign_in_url
  end

  test "should get new when authenticated" do
    sign_in_as(@user)
    get new_bakery_url
    assert_response :success
  end

  test "should create bakery when authenticated" do
    sign_in_as(@user)
    assert_difference("Bakery.count") do
      post bakeries_url, params: {
        bakery: {
          name: Faker::Restaurant.name,
          description: Faker::Restaurant.description
        }
      }
    end
    assert_redirected_to bakery_url(Bakery.last)
    # Verify the current user is the owner
    assert_equal @user, Bakery.last.bakery_memberships.owner.first.user
  end

  test "should show bakery" do
    get bakery_url(@bakery)
    assert_response :success
  end

  test "should get index" do
    get bakeries_url
    assert_response :success
  end

  test "should allow owner to edit bakery" do
    sign_in_as(@user)
    get edit_bakery_url(@bakery)
    assert_response :success
  end

  test "should allow owner to update bakery" do
    sign_in_as(@user)
    patch bakery_url(@bakery), params: {
      bakery: {name: "New Name", description: "New description"}
    }
    assert_redirected_to bakery_url(@bakery)
    assert_equal "Bakery updated!", flash[:notice]
  end

  test "should not allow non-owner to edit bakery" do
    sign_in_as(@other_user)
    get edit_bakery_url(@bakery)
    assert_redirected_to bakery_url(@bakery)
    assert_equal "Only bakery owners can perform this action", flash[:alert]
  end

  test "should not allow non-owner to update bakery" do
    sign_in_as(@other_user)
    patch bakery_url(@bakery), params: {
      bakery: {name: "New Name", description: "New description"}
    }
    assert_redirected_to bakery_url(@bakery)
    assert_equal "Only bakery owners can perform this action", flash[:alert]
  end
end
