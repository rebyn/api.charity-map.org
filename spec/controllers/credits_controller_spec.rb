require 'spec_helper'

describe CreditsController do
	before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
    request.env["HTTPS"] = 'on'
  end

  describe "GET index" do
  	it "requires params[:email]" do
      get :index
      expect(response.status).to eq(400)
      expect(response.body).to eq({:"error" => "Missing required params[:email]"}.to_json)
    end

    it "returns credits not found" do
      user = FactoryGirl.create(:user)
      transaction = FactoryGirl.create(:transaction)
      get :index, {email: "merchant@company.com"}
      expect(response.status).to eq(200)
      expect(response.body).to eq({:"message" => "There were no credits of this user"}.to_json)
    end

    it "should return credits for individual account" do
    	@params = {email: "tu@charity-map.org"}
    	@user = User.create email: "tu@charity-map.org"
    	@transaction = FactoryGirl.create(:transaction)
    	@credit = @user.credits.create master_transaction_id: "1234567890", amount: 100000, currency: "VND"
    	@credit.update_attribute :uid, "0987654321"
    	get :index, @params
    	expect(response.status).to eq(200)
    	expect(response.body).should have_node(:uuid).with("0987654321")
    	expect(response.body).should have_node(:email).with("tu@charity-map.org")
    	expect(response.body).should have_node(:amount).with(100000)
    	expect(response.body).should have_node(:currency).with("VND")
    end

    it "should return credits for organization" do
    	@params = {email: "cuong@social.org"}
    	@merchant = User.create email: "merchant@company.com"
    	@social_org = User.create email: "cuong@social.org"
    	@social_org.update_attribute :category, "SOCIALORG"
    	@merchant.update_attributes(name: "Merchant Corp", contact: "227 Nguyen Van Cu, TP.HCM")
    	@transaction = FactoryGirl.create(:transaction)
    	@credit = @social_org.credits.create master_transaction_id: "1234567890", amount: 40000, currency: "VND"
    	@credit2 = @social_org.credits.create master_transaction_id: "1234567890", amount: 60000, currency: "VND"
    	@credit2.update_attributes(uid: "0007654321", status: "CLEARED")  
    	@credit.update_attribute :uid, "0987654321"
    	get :index, @params
    	expect(response.status).to eq(200)
    	expect(response.body).should have_node(:UNPROCESSED)
    	expect(response.body).should have_node(:CLEARED)
    	expect(response.body).should have_node(:uuid).with("0987654321")
    	expect(response.body).should have_node(:amount).with(40000)
    	expect(response.body).should have_node(:uuid).with("0007654321")
    	expect(response.body).should have_node(:amount).with(60000)
    	expect(response.body).should have_node(:email).with("merchant@company.com")
    	expect(response.body).should have_node(:name).with("Merchant Corp")
    	expect(response.body).should have_node(:contact).with("227 Nguyen Van Cu, TP.HCM")
    	expect(response.body).should have_node(:currency).with("VND")
    end
  end
end