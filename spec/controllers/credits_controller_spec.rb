require 'spec_helper'

describe V1::CreditsController do
  describe "Without Token" do
    before :each do
      @app = User.create email: "merchant@company.com"   
      request.env["HTTP_ACCEPT"] = 'application/json'
      request.env["HTTPS"] = 'on'
    end

    it "should not access action with no auth token" do
      post :index
      expect(response.status).to eq(401)      
      expect(response.body).to eq("HTTP Token: Access denied.\n")
    end
  end

  describe "With Wrong Token" do
    before :each do
      @app = User.create email: "merchant@company.com"   
      request.env["HTTP_ACCEPT"] = 'application/json'
      request.env["HTTPS"] = 'on'
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{@app.auth_token.value}1"
    end

    it "should not access action with invalid auth token" do
      post :index
      expect(response.status).to eq(401)      
      expect(response.body).to eq("HTTP Token: Access denied.\n")
    end
  end

  describe "With Token" do
  	before :each do
      @app = User.create email: "merchant@company.com"
      @app.update_attribute :category, "MERCHANT"
      @user = User.create email: "cuong@individual.net"
      @org = User.create email: "love@social.org"
      @org.update_attribute :category, "SOCIALORG"
      request.env["HTTP_ACCEPT"] = 'application/json'
      request.env["HTTPS"] = 'on'
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{@app.auth_token.value}"
    end

    describe "GET index" do
    	it "requires params[:email]" do
        get :index
        expect(response.status).to eq(400)
        expect(response.body).to eq({:"error" => "Missing required params[:email] or params[:master_transaction_id]"}.to_json)
      end

      it "returns credits not found" do
        get :index, { email: "merchant@company.com" }
        expect(response.status).to eq(400)
        expect(response.body).to eq({:"error" => "No associated credits"}.to_json)
      end

      it "should return unprocessed credits" do
        @transaction = FactoryGirl.create(:transaction)
        @credit = @user.credits.create master_transaction_id: @transaction.uid, amount: 100000, currency: "VND"

        @params = {email: @user.email}
        get :index, @params
        expect(response.body).to have_node(:uid)
        expect(response.body).to have_node(:amount).with(100000)
        expect(response.body).to have_node(:currency).with("VND")
        expect(response.body).to have_node(:status).with("UNPROCESSED")
        expect(response.body).to have_node(:created_at)
        expect(response.status).to eq(200)
      end

      it "should return cleared credits" do
        @transaction = FactoryGirl.create(:transaction)
        @credit = @user.credits.create master_transaction_id: @transaction.uid, amount: 100000, currency: "VND"
        @credit.update_attribute :status, "CLEARED"

        @params = {email: @user.email}
        get :index, @params
        expect(response.body).to have_node(:uid)
        expect(response.body).to have_node(:status).with("CLEARED")
        expect(response.body).to have_node(:created_at)
        expect(response.status).to eq(200)
      end

      it "should return pending clearance" do
        @transaction = FactoryGirl.create(:transaction)
        @credit = @user.credits.create master_transaction_id: @transaction.uid, amount: 100000, currency: "VND"

        @params = {master_transaction_id: @transaction.uid}
        get :index, @params
        expect(response.body).to have_node(:uid)
        expect(response.body).to have_node(:status).with("UNPROCESSED")
        expect(response.body).to have_node(:created_at)
        expect(response.status).to eq(200)
      end
    end
  end
end