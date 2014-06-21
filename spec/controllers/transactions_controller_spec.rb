require 'spec_helper'

describe V1::TransactionsController do
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
      request.env["HTTP_ACCEPT"] = 'application/json'
      request.env["HTTPS"] = 'on'
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{@app.auth_token.value}"
    end

    describe "GET index" do
      it "requires params[:email]" do
        get :index
        expect(response.status).to eq(400)
        expect(response.body).to eq(
          {:"error" => "Missing required params[:email]"}.to_json)
      end

      it "checks for User email" do
        get :index, {email: "merchant123@company.com"}
        expect(response.status).to eq(400)
        expect(response.body).to eq(
          {:"error" => "Email not found"}.to_json)
      end

      it "returns User with no transactions" do
        get :index, {email: "merchant@company.com"}
        expect(response.body).to eq(
          {:"error" => "Transactions Not Found"}.to_json)
        expect(response.status).to eq(400)
      end

      it "returns User with transactions" do
        @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 100000, currency: "VND"}
        @user = User.create email: "cuong@individual.net"
        post :index, @params
        get :index, {email: "merchant@company.com"}
        expect(response.body).to have_node(:from).with("merchant@company.com")
        expect(response.body).to have_node(:to).with("cuong@individual.net")
        expect(response.body).to have_node(:amount).with(100000.0)
        expect(response.body).to have_node(:url)
        expect(response.body).to have_node(:status).with("Authorized")
        expect(response.status).to eq(200)
      end
    end

    describe "PUT/POST index invalid" do
      it "should not create a new transaction with invalid params" do
        # :from account is not created yet
        @params = {from: "unregistered_merchant@company.com", to: "cuong@individual.net", amount: 100000, currency: "VND"}
        post :index, @params
        expect(response.body).to eq(
          {:"error" => "Sender Email Not Found."}.to_json)
        expect(response.status).to eq(400)
        # :from account doesn't have enough credit
        @params = {from: "cuong@individual.net", to: "love@social.org", amount: 100000, currency: "VND"}
        @user2 = User.create email: "cuong@individual.net"
        @user3 = User.create email: "love@social.org"
        post :index, @params
        expect(response.body).to eq(
          {:"error" => "Not Having Enough Credit To Perform The Transaction."}.to_json)
        # :from account is sending credit to merchant or individual accounts
        @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 100000, currency: "VND"}
        post :index, @params
        @params = {from: "cuong@individual.net", to: "merchant@company.com", amount: 100000, currency: "VND"}
        post :index, @params
        expect(response.body).to eq(
          {:"error" => "Credits Restricted To Be Sent Only to Organizational Accounts."}.to_json)
      end
    end

    describe "PUT/POST index invalid" do
      before :each do
        @user = User.create email: "cuong@individual.net"
        @org = User.create email: "social@social.org"
        @org.update_attribute :category, "SOCIALORG"
      end

      it "should create a new transaction with valid params" do
        @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 100000, currency: "VND"}
        post :index, @params
        expect(response.status).to eq(201)
        expect(response.body).to have_node(:status).with("Authorized")
        @transaction = Transaction.take
        @before_sum = Credit.where(master_transaction_id: @transaction.uid).sum(:amount)
        
        @params = {from: "cuong@individual.net", to: "social@social.org", amount: 100000, currency: "VND"}
        post :index, @params
        expect(response.status).to eq(201)
        expect(response.body).to have_node(:to).with("social@social.org")
        expect(response.body).to have_node(:status).with("NotAuthorized")
        # test credit sum before and after
        @after_sum = Credit.where(master_transaction_id: @transaction.uid).sum(:amount)
        @before_sum.should eq(@after_sum)
        Credit.count.should eq(1)
        # test credit being transfered to cuong@individual.net
        Credit.where(master_transaction_id: @transaction.uid).last.user.should eq(@user)

        get :authorize, {token: Transaction.unauthorized.first.token.value}
        Credit.count.should eq(2)
        Credit.find_by(master_transaction_id: @transaction.uid, amount: 100000).user.should eq(@org)
      end

      it "should create a new transaction with valid params (+2 credits)" do
        @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 100000, currency: "VND"}
        post :index, @params
        @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 50000, currency: "VND"}
        post :index, @params
        @params = {from: "cuong@individual.net", to: "social@social.org", amount: 125000, currency: "VND"}
        post :index, @params
        get :authorize, {token: Transaction.unauthorized.first.token.value}
        Credit.count.should eq(4)
        @org.credits.pluck(:master_transaction_id).should eq(@app.transactions.pluck(:uid))
      end

      it "should create a new transaction with valid params (+3 credits)" do
        @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 100000, currency: "VND"}
        post :index, @params
        @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 50000, currency: "VND"}
        post :index, @params
        @params = {from: "merchant@company.com", to: "cuong@individual.net", amount: 25000, currency: "VND"}
        post :index, @params
        @params = {from: "cuong@individual.net", to: "social@social.org", amount: 170000, currency: "VND"}
        post :index, @params
        get :authorize, {token: Transaction.unauthorized.first.token.value}
        Credit.count.should eq(6)
        @org.credits.pluck(:master_transaction_id).should eq(@app.transactions.pluck(:uid))
      end

      it "should create user if to[email] isn't on the system" do
        @params = {from: "merchant@company.com", to: "non_existent_user@individual.net", amount: 100000, currency: "VND"}
        post :index, @params
        expect(User.where(email: "non_existent_user@individual.net")).to exist
      end
    end
  end
end
