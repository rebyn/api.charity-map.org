require 'spec_helper'

describe V1::UsersController do
  describe "Action with Auth Token" do

    before :each do
      @admin_token = ENV['API_CREATE_USER_TOKEN']
      request.env["HTTP_ACCEPT"] = 'application/json'
      request.env["HTTPS"] = 'on'
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{@admin_token}"      
    end

    describe "Create User" do
      it "should create a user and returning auth token" do
      	@params = {email: "merchant@company.com", category: "MERCHANT"}
        post :create, @params
        # ActionMailer::Base.deliveries.last.to.should == ["merchant@company.com"]
        expect(response.status).to eq(201)
        expect(response.body).to have_node(:auth_token)
      end

      it "should not create a user with missing params" do
      	@params = {category: "MERCHANT"}
        post :create, @params
        expect(response.status).to eq(400)
        expect(response.body).to eq({:"error" => "Missing required params"}.to_json)
      end

      it "should not create a user with invalid email" do
        @params = {category: "MERCHANT", email: "abc@invalid_email"}
        post :create, @params
        expect(response.status).to eq(400)
        expect(response.body).to eq({:"error" => "Email is invalid"}.to_json)
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