require 'rails_helper'

RSpec.describe "Connections", type: :request do
  before(:all) do
    @user = create(:user)
  end

  describe "GET /index" do
    it "renders the index template when the route is /connections" do
      sign_in @user
      get connections_path
      expect(response).to be_successful
    end
  end
end
