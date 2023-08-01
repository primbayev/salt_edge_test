require "rails_helper"

describe "User signs in", type: :system do
  before do
    @connection = create(:connection)
    @user = @connection.customer.user
    visit new_user_session_path
  end

  it "valid with correct credentials" do
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button "Log in"

    expect(page).to have_text "Signed in successfully."
  end

  it "invalid with wrong credentials" do
    fill_in "user_email", with: Faker::Internet.email
    fill_in "user_password", with: ""
    click_button "Log in"

    expect(page).to have_text "Forgot your password"
    expect(page).to have_no_link "Log out"
  end
end
