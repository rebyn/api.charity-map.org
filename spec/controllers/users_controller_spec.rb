require 'spec_helper'

describe V1::UsersController do
  describe "Action with Auth Token" do

    before :each do
      request.env["HTTP_ACCEPT"] = 'application/json'
      request.env["HTTPS"] = 'on'
      request.env["HTTP_AUTHORIZATION"] = "Token token=ABCabc"
    end

    describe "Create User" do
      it "should create a user and returning auth token" do
      	@params = {email: "merchant@company.com", category: "MERCHANT"}
        post :create, @params
        expect(response.status).to eq(200)
        expect(response.body).to have_node(:auth_token)
      end

      it "should not create a user with invalid params" do
      	@params = {category: "MERCHANT"}
        post :create, @params
        expect(response.status).to eq(400)
        expect(response.body).to eq({:"error" => "Cannot create user"}.to_json)
      end
    end
  end

  describe "Check Auth Token" do
    before :each do
      request.env["HTTP_ACCEPT"] = 'application/json'
      request.env["HTTPS"] = 'on'
      request.env["HTTP_AUTHORIZATION"] = "Token token=FAKE_TOKEN"
    end

    it "should not access action with invalid auth token" do
      @params = {email: "merchant@company.com", category: "MERCHANT"}
      post :create, @params
      expect(response.status).to eq(401)      
      expect(response.body).to eq("HTTP Token: Access denied.\n")
    end
  end
end