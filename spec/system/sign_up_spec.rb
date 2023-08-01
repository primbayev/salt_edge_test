require "rails_helper"

describe "User signs up", type: :system do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  let(:email) { 'qwerty@qwerty' }
  let(:password) { Faker::Internet.password(min_length: 8) }

  before do
    visit new_user_registration_path
  end

  it "with valid data" do
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    fill_in "user_password_confirmation", with: password
    click_button "Sign up"

    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Log in'

    expect(page).to have_text 'Signed in successfully'
  end

  it "invalid when email already exists" do
    user = create :user

    fill_in "user_email", with: user.email
    fill_in "user_password", with: password
    fill_in "user_password_confirmation", with: password
    click_button "Sign up"

    expect(page).to have_text "Sign up"
  end
end
