require "test_helper"

class BakeriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bakery = create(:bakery)
  end

  test "should redirect to sign in when not authenticated" do
    get new_bakery_url
    assert_redirected_to sign_in_url

    post bakeries_url, params: { bakery: { name: Faker::Restaurant.name, description: Faker::Restaurant.description } }
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
end