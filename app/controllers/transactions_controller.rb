class TransactionsController < ApplicationController
  before_filter :check_app_authorization

  # DOC: https://github.com/rebyn/api.charity-map.org/blob/master/docs/transactions.md#get-transactions
  def index
    if (!request.post? && !request.put?)
      @user = User.find_by_email(params[:email])
      if params[:email] && @user
        @transactions = Transaction.where(sender_email: params[:email]).authorized
        respond_to do |format|
          format.json {render}
        end
      else
        render json: (params[:email] ? {"error" => "Email not found"} : {"error" => "Missing required params[:email]"}), status: 400
      end
    else # handle PUT/POST
      @user = User.find_or_create_by_email params[:to]
      @sender_user = User.find_by_email(params[:from])
      @recipient_user = User.find_by_email(params[:to])
      # TODO: send email when creating new User
      @result = validate_create_transaction(params, @sender_user, @recipient_user)            
      if @result != ""
        render json: {"error" => @result}, status: 400
      else
        @transaction = create_transaction(params, (params[:from] == @app[:email] ? 'Authorized' : 'NotAuthorized'))        
        # UserMailer.ask_to_authorize_transaction(@transaction).deliver if !@transaction.authorized?
        # TODO: send email when creating an NotAuthorized transaction
        # TODO: transaction.status == "Authorized"
        if @transaction 
          if @sender_user.category == "MERCHANT"
            @credit = @recipient_user.credits.create(master_transaction_id: @transaction.uid, amount: params[:amount])            
          else
            @credit = create_credit_by_invidual_user(@sender_user, @recipient_user, @transaction)
          end
          if @credit
            respond_to do |format|
              format.json {render(template: '/transactions/create.json.jbuilder', status: 200)}
            end
          else
            render json: {"error" => "Fail to create credit"}, status: 400
          end
        else
          render json: {"error" => "Fail to create transaction"}, status: 400
        end
      end
    end
  end

  def create_transaction(params, status)
    @transaction = Transaction.create(
      sender_email: params[:from], recipient_email: params[:to],
      amount: params[:amount], currency: params[:currency],
      references: params[:references]
    )
    @transaction.update_attribute :status, status if status == 'Authorized'
    return @transaction
  end

  def create_credit_by_invidual_user(sender_user, recipient_user, transaction)
    # MUST NOT REMOVE "!" in below code lines
    @temp_amount = params[:amount].to_f
    @is_successfully = false    
    Credit.transaction do      
      sender_user.credits.each do |credit|
        if credit.amount < @temp_amount
          @temp_amount = @temp_amount - credit.amount
          @created_credit = recipient_user.credits.create!(master_transaction_id: credit.master_transaction_id, amount: credit.amount)
          credit.update_attributes!(amount: 0, status: "PROCESSED")
        elsif credit.amount > @temp_amount
          @created_credit = recipient_user.credits.create!(master_transaction_id: credit.master_transaction_id, amount: @temp_amount)
          # PROCESSED OR UNPROCESSED ?
          credit.update_attributes!(amount: credit.amount - @temp_amount, status: "PROCESSED")          
          @is_successfully = true
          break
        else          
          @created_credit = recipient_user.credits.create!(master_transaction_id: credit.master_transaction_id, amount: credit.amount)
          credit.update_attributes!(amount: 0, status: "PROCESSED")          
          @is_successfully = true
          break
        end
      end
    end
    return @is_successfully
  end
  def authorize
    token_value = params[:token]
    transaction_id = params[:transaction_id]
    transaction = Transaction.find(transaction_id)
    if transaction
      token = Token.where("transaction_id = ? AND expiry_date >= ? AND status = ?", transaction.uid, DateTime.now, "new").first
      if token
        transaction.update_attributes(status: 'authorized')
        token.update_attributes(status: 'used')
      end
    end

  end

  def print_transactions(json, transactions, user)
    json.array!(transactions) do |transaction|
      json.uid transaction.uid
      json.from transaction.sender_email
      json.to transaction.recipient_email
      json.amount transaction.amount
      json.currency transaction.currency
      json.description transaction.references
      json.(transaction, :created_at)
      json.url transaction.url              
    end
  end

  def validate_create_transaction(params, sender_user, recipient_user)
    if !sender_user
      return "Sender Email Not Found"
    end
    if !recipient_user
      return "Recipient Email Not Found"
    end 
    if sender_user.category != "MERCHANT" && Credit.where(:user_id => sender_user.id, :status => "UNPROCESSED").sum(:amount) < params[:amount].to_f
      return "Not Having Enough Credit To Perform The Transaction"
    end
    if recipient_user.category == "MERCHANT" || (sender_user.category != "MERCHANT" && recipient_user.category == "INDIVIDUAL")
      return "Credits Restricted To Be Sent Only to Organizational Accounts"
    end
    if !params[:currency] || params[:currency] == ''
      return "Credits Need To Be Set The Currency"
    end
    return ""
  end

  private
    def check_app_authorization
      true
      @app = Hash.new({:token => "ABCDEF", :email => "tu@merchant.com"})
    end
end
