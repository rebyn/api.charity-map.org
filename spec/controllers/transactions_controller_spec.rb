require 'spec_helper'

describe TransactionsController do
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
    request.env["HTTPS"] = 'on'
  end

  describe "GET index" do
    it "requires params[:email]" do
      get :index
      expect(response.status).to eq(400)
      expect(response.body).to eq(
        {:"error" => "Missing required params[:email]"}.to_json)
    end

    it "checks for User email" do
      get :index, {email: "merchant@company.com"}
      expect(response.status).to eq(400)
      expect(response.body).to eq(
        {:"error" => "Email not found"}.to_json)
    end

    it "returns User with no transactions" do
      user = FactoryGirl.create(:user)
      get :index, {email: "merchant@company.com"}
      expect(response.body).to eq(
        {:"message" => "Transactions Not Found"}.to_json)
      expect(response.status).to eq(200)
    end

    it "returns User with transactions" do
      user = FactoryGirl.create(:user)
      transaction = FactoryGirl.create(:transaction)
      get :index, {email: "merchant@company.com"}
      expect(response.body).to eq(
        {:"message" => "Transactions Not Found"}.to_json)
      expect(response.status).to eq(200)
    end

    it "returns User with transactions" do
      user = FactoryGirl.create(:user)
      transaction = FactoryGirl.create(:transaction)
      transaction.update_attribute :status, "Authorized"
      get :index, {email: "merchant@company.com"}
      expect(response.body).to eq([{
        "uid" => "1234567890", "from" => "merchant@company.com",
        "to" => "cuong@individual.net", "amount" => 100000.0,
        "currency" => "VND", "references" => "",
        "created_at" => "2014-01-08T22:16:54.000Z",
        "url" => "https://api.charity-map.org/transactions/1234567890"}].to_json)
      expect(response.status).to eq(200)
    end
  end

  describe "PUT/POST index" do
    it "should not create a new transaction with invalid params" do
      # :from account is not created yet
      @params = {from: "merchant@company.com", to: "cuong@individual.org", amount: 100000, currency: "VND"}
      post :index, @params
      expect(response.body).to eq(
        {:"error" => "Sender Email Not Found. Recipient Email Not Found."}.to_json)
      expect(response.status).to eq(400)
      # :from account doesn't have enough credit
      @user = User.create email: "merchant@company.com"
      @user2 = User.create email: "cuong@individual.org"
      post :index, @params
      expect(response.body).to eq(
        {:"error" => "Not Having Enough Credit To Perform The Transaction."}.to_json)
      # :from account is sending credit to merchant or individual accounts
      @transaction = FactoryGirl.create(:transaction)
      @user.credits.create master_transaction_id: "1234567890", amount: 100000, currency: "VND"
      post :index, @params
      expect(response.body).to eq(
        {:"error" => "Credits Restricted To Be Sent Only to Organizational Accounts."}.to_json)
    end

    it "should create a new transaction with valid params" do
      @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 100000, currency: "VND"}
      @user = User.create email: "merchant@company.com"
      @user2 = User.create email: "cuong@individual.net"
      @user2.update_attribute :category, "SOCIALORG"
      @transaction = FactoryGirl.create(:transaction)
      @user.credits.create master_transaction_id: "1234567890", amount: 100000, currency: "VND"
      @before_sum = Credit.where(master_transaction_id: "1234567890").sum(:amount)
      post :index, @params
      expect(response.body).should have_node(:from).with("merchant@company.com")
      expect(response.status).to eq(200)
      expect(response.body).should have_node(:to).with("cuong@individual.net")
      expect(response.body).should have_node(:amount).with(100000.0)
      expect(response.body).should have_node(:currency).with("VND")
      expect(response.body).should have_node(:status).with("NotAuthorized")
      # test credit sum before and after
      @after_sum = Credit.where(master_transaction_id: "1234567890").sum(:amount)
      @before_sum.should eq(@after_sum)
      Credit.count.should eq(2)
      # test credit being transfered to cuong@individual.net
      Credit.where(master_transaction_id: "1234567890").last.user.should eq(@user2)
    end

    it "should create a new transaction with valid params (+2 credits)" do
      @params = {from: "cuong@individual.net", to: "charity@gmail.com", amount: 125000, currency: "VND"}
      @user = User.create email: "cuong@individual.net"
      @user2 = User.create email: "charity@gmail.com"
      @user2.update_attribute :category, "SOCIALORG"
      @transaction = FactoryGirl.create(:transaction)
      @another_transaction = FactoryGirl.create(:transaction, uid: "1234567891", amount: 50000, sender_email: "another_merchant@company.com")
      @user.credits.create master_transaction_id: "1234567890", amount: 100000, currency: "VND"
      @user.credits.create master_transaction_id: "1234567891", amount: 50000, currency: "VND"
      @before_sum = Credit.where(master_transaction_id: "1234567890").sum(:amount)
      post :index, @params
      expect(response.body).should have_node(:from).with("cuong@individual.net")
      expect(response.status).to eq(200)
      expect(response.body).should have_node(:to).with("charity@gmail.com")
      expect(response.body).should have_node(:amount).with(125000.0)
      expect(response.body).should have_node(:currency).with("VND")
      expect(response.body).should have_node(:status).with("NotAuthorized")
      # test credit sum before and after
      @after_sum = Credit.where(master_transaction_id: "1234567890").sum(:amount)
      @before_sum.should eq(@after_sum)
      Credit.count.should eq(4) # two new Credit objects being created
      # test credit being transfered to charity@gmail.com
      @user2.credits.count.should eq(2)
      @user2.credits.sum(:amount).should eq(125000)
      @user.credits.pluck(:master_transaction_id).sort.should eq(["1234567890", "1234567891"])
    end

    it "should create a new transaction with valid params (+3 credits)" do
      @params = {from: "cuong@individual.net", to: "charity@gmail.com", amount: 170000, currency: "VND"}
      @user = User.create email: "cuong@individual.net"
      @user2 = User.create email: "charity@gmail.com"
      @user2.update_attribute :category, "SOCIALORG"
      @transaction = FactoryGirl.create(:transaction)
      @transaction_2 = FactoryGirl.create(:transaction, uid: "1234567891", amount: 50000, sender_email: "another_merchant@company.com")
      @transaction_3 = FactoryGirl.create(:transaction, uid: "1234567892", amount: 25000, sender_email: "another_merchant@company.com")
      @user.credits.create master_transaction_id: "1234567890", amount: 100000, currency: "VND"
      @user.credits.create master_transaction_id: "1234567891", amount: 50000, currency: "VND"
      @user.credits.create master_transaction_id: "1234567892", amount: 25000, currency: "VND"
      @before_sum = Credit.where(master_transaction_id: "1234567892").sum(:amount)
      post :index, @params
      expect(response.body).should have_node(:from).with("cuong@individual.net")
      expect(response.status).to eq(200)
      expect(response.body).should have_node(:to).with("charity@gmail.com")
      expect(response.body).should have_node(:amount).with(170000.0)
      expect(response.body).should have_node(:currency).with("VND")
      expect(response.body).should have_node(:status).with("NotAuthorized")
      # test credit sum before and after
      @after_sum = Credit.where(master_transaction_id: "1234567892").sum(:amount)
      @before_sum.should eq(@after_sum)
      Credit.count.should eq(6) # two new Credit objects being created
      # test credit being transfered to charity@gmail.com
      @user2.credits.count.should eq(3)
      @user2.credits.sum(:amount).should eq(170000)
      @user.credits.pluck(:master_transaction_id).sort.should eq(["1234567890", "1234567891", "1234567892"])
    end
  end
end
