require 'test_helper'

class RegisterAndLoginTest < ActionDispatch::IntegrationTest
  context "registration" do
    context "with a valid email and password" do
      setup do
        @name = Faker::Name.name
        @email = Faker::Internet.email
        @password = default_password
      end

      should "be able to register as a user" do
        assert_difference "User.count" do
          visit new_user_path
          fill_in "Name", with: @name
          fill_in "Email", with: @email
          fill_in "Password", with: @password
          fill_in "Password confirmation", with: @password
          click_on "Register"
        end

        assert_equal root_path, current_path
        assert page.has_content?("registered")
        assert page.has_content?("Logged in as #{@name}")
      end
    end
  end

  def assert_can_login(user, password)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Login"

    assert_equal root_path, current_path
    assert page.has_content?("Logged in as #{user.name}")
  end

  context "login" do
    context "with a valid email and password" do
      should "be able to login" do
        assert_can_login(users(:one), default_password)
      end
    end
  end

  context "logout" do
    context "when logged in" do
      setup do
        login
      end

      should "be able to log out" do
        visit root_path
        click_on "Log out"

        assert_equal root_path, current_path
        assert page.has_content?("logged out")
      end
    end
  end

  context "password_reset" do
    context "with a valid email" do
      setup do
        @user = users(:one)
        @email = @user.email
      end

      should "be able to reset password" do
        visit login_path
        click_on "Forgot your password?"
        fill_in "Email", with: @email
        click_on "Reset your password"

        assert_equal 1, unread_emails_for(@email).size
        open_last_email_for(@email)
        assert_must have_subject("Password reset for Question Box"), current_email
        click_email_link_matching /reset/

        fill_in "Password", with: "new_password"
        fill_in "Password confirmation", with: "new_password"
        click_on "Change your password"

        assert page.has_content?("password has been changed")

        assert_can_login(@user, "new_password")
      end
    end
  end
end
