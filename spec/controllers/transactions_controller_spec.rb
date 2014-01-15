require 'spec_helper'

describe TransactionsController do
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET index" do
    it "requires params[:email]" do
      get :index
      expect(response.status).to eq(400)
      expect(response.body).to eq({:"error" => "Missing required params[:email]"}.to_json)
    end

    it "checks for User email" do
      get :index, {email: "tu@charity-map.org"}
      expect(response.status).to eq(400)
      expect(response.body).to eq({:"error" => "Email not found"}.to_json)
    end

    it "returns User with no transactions" do
      user = FactoryGirl.create(:user)
      get :index, {email: "tu@charity-map.org"}
      expect(response.status).to eq(200)
      expect(response.body).to eq({:"message" => "Transactions Not Found"}.to_json)
    end

    it "returns User with transactions" do
      user = FactoryGirl.create(:user)
      transaction = FactoryGirl.create(:transaction)
      get :index, {email: "tu@charity-map.org"}
      expect(response.status).to eq(200)
      expect(response.body).to eq({:"message" => "Transactions Not Found"}.to_json)
    end

    it "returns User with transactions" do
      user = FactoryGirl.create(:user)
      transaction = FactoryGirl.create(:transaction)
      transaction.update_attribute :status, "Authorized"
      get :index, {email: "tu@charity-map.org"}
      expect(response.status).to eq(200)
      expect(response.body).to eq([{
        "uid" => "0123456789", "from" => "tu@charity-map.org",
        "to" => "individual@gmail.com", "amount" => 100000.0,
        "currency" => "VND", "references" => "",
        "created_at" => "2014-01-08T22:16:54.000Z",
        "url" => "https://api.charity-map.org/transactions/0123456789"}].to_json)
    end
  end

  describe "PUT/POST index" do
    it "should not create a new transaction with invalid params" do
      # :from account is not created yet
      @params = {from: "tu@charity-map.org", to: "cuong@individual.org", amount: 100000, currency: "VND"}
      post :index, @params
      expect(response.body).to eq({:"error" => "Sender Email Not Found"}.to_json)
      expect(response.status).to eq(400)
      # :from account doesn't have enough credit
      @user = User.create email: "tu@charity-map.org"
      post :index, @params
      expect(response.body).to eq({:"error" => "Not Having Enough Credit To Perform The Transaction"}.to_json)
      # :from account is sending credit to merchant or individual accounts
      @user.credits.create master_transaction_id: "1234567890", amount: 100000
      post :index, @params
      expect(response.body).to eq({:"error" => "Credits Restricted To Be Sent Only to Organizational Accounts"}.to_json)
    end

    it "should create a new transaction with valid params" do
      @params = {from: "tu@charity-map.org", to: "cuong@individual.org", amount: 100000, currency: "VND"}
      @user = User.create email: "tu@charity-map.org"
      @user2 = User.create email: "cuong@individual.org"
      @user2.update_attribute :category, "SOCIALORG"
      @user.credits.create master_transaction_id: "1234567890", amount: 100000
      @before_sum = Credit.where(master_transaction_id: "1234567890").sum(:amount)
      post :index, @params
      expect(response.status).to eq(200)
      expect(response.body).should have_node(:from).with("tu@charity-map.org")
      expect(response.body).should have_node(:to).with("cuong@individual.org")
      expect(response.body).should have_node(:amount).with(100000.0)
      expect(response.body).should have_node(:currency).with("VND")
      expect(response.body).should have_node(:status).with("NotAuthorized")
      # test credit sum before and after
      @after_sum = Credit.where(master_transaction_id: "1234567890").sum(:amount)
      @before_sum.should eq(@after_sum)
      # test credit being transfered to cuong@individual
      Credit.where(master_transaction_id: "1234567890").first.user.should eq(@user2)
    end
  end
end
