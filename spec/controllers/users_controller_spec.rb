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

    it "should get balance" do
      # Missing params[:email]
      get :balance
      expect(response.body).to eq({:"error" => "Missing required params[:email]"}.to_json)
      # User doesn't exist
      get :balance, {email: "cuong@individual.net"}
      expect(response.body).to eq({:"error" => "Missing required params[:email]"}.to_json)
      @user = User.create! email: "cuong@individual.net"
      # User to have no credits
      get :balance, {email: @user.email}
      expect(response.body).to eq({:"balance" => 0.0}.to_json)
      # User to have a positive credit balance
      @transaction = FactoryGirl.create(:transaction)
      @user.credits.create! master_transaction_id: @transaction.uid, amount: 100000, currency: "VND"
      get :balance, {email: @user.email}
      expect(response.body).to eq({:"balance" => 100000.0}.to_json)
      expect(response.status).to eq(200)
    end

    it "should get user info" do
      get :show
      expect(response.body).to eq({:"error" => "Missing required params[:email]"}.to_json)
      expect(response.status).to eq(400)
      get :show, {email: "cuong@individual.net"}
      expect(response.body).to eq({:"error" => "User Not Found"}.to_json)
      expect(response.status).to eq(400)
      @user = User.create! email: "cuong@individual.net"
      get :show, {email: "cuong@individual.net"}
      expect(response.body).to have_node(:email).with("cuong@individual.net")
      expect(response.body).to have_node(:auth_token)
      expect(response.body).to have_node(:category).with("INDIVIDUAL")
      @user.update_attribute :category, "MERCHANT"
      get :show, {email: "cuong@individual.net"}
      expect(response.body).to have_node(:category).with("MERCHANT")
    end

    it "should update user info" do
      post :update
      expect(response.body).to eq({:"error" => "Missing required params[:email]"}.to_json)
      expect(response.status).to eq(400)
      post :update, {email: "cuong@individual.net"}
      expect(response.body).to eq({:"error" => "User Not Found"}.to_json)
      expect(response.status).to eq(400)
      @user = User.create! email: "cuong@individual.net"
      post :update, {email: "cuong@individual.net"}
      expect(response.body).to have_node(:email).with("cuong@individual.net")
      expect(response.body).to have_node(:auth_token)
      expect(response.body).to have_node(:category).with("INDIVIDUAL")
      post :update, {email: "cuong@individual.net", category: "MERCHANT"}
      expect(response.body).to have_node(:category).with("MERCHANT")
      post :update, {email: "cuong@individual.net", category: "SOCIALORG"}
      expect(response.body).to have_node(:category).with("SOCIALORG")
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