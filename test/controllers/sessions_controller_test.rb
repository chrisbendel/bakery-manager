require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "should get new" do
    get sign_in_url
    assert_response :success
  end

  test "should sign in" do
    post sign_in_url, params: { email: @user.email, password: "Secret1*3*5*" }
    assert_redirected_to root_url

    get root_url
    assert_response :success
  end

  test "should not sign in with wrong credentials" do
    post sign_in_url, params: { email: @user.email, password: "SecretWrong1*3" }
    assert_equal "Invalid email or password", flash[:alert]
    assert_response :unprocessable_entity

    assert_select 'input[value=?]', @user.email
  end

  test "should sign out" do
    sign_in_as @user

    delete sign_out_path
    assert_redirected_to root_path
  end
end
