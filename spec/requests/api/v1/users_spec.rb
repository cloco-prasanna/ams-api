require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let!(:user) { create(:user, email: "test@admin.com", password: "password2") }

  describe "GET /users" do
    it "gets all users" do
      get "/api/v1/users"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /auth/register" do
    it "registers a user" do
      user_params = {
        user: {
          first_name: "test",
          last_name: "user resp",
          email: "rspec@admin.com",
          password: "password",
          role: "user",
          gender: "male"
        }
      }
      post "/api/v1/auth/register", params: user_params
      expect(response).to have_http_status(:created)
    end
  end

  describe "GET /users/1" do
    it "gets a user by its id" do
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /auth/login" do
    it "logs in user and returns token" do
      login_params = {
        user: {
          email: "test@admin.com",
          password: "password2"
        }
      }
      post "/api/v1/auth/login", params: login_params
      expect(response).to have_http_status(:ok)
    end
  end
end
