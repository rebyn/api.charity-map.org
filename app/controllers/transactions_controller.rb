class TransactionsController < ApplicationController
  before_filter :check_app_authorization

  # DOC: https://github.com/rebyn/api.charity-map.org/blob/master/docs/transactions.md#get-transactions
  def index
    if (!request.post? && !request.put?)
      @user = User.find_by_email(params[:email])
      if params[:email] && @user
        @transactions= Transaction.where(sender_email: params[:email]).authorized
        respond_to do |format|
          format.json {render}
        end
      else
        render json: (params[:email] ? {"error" => "Email not found"} : {"error" => "Missing required params[:email]"}), status: 400
      end
    else # handle PUT/POST
      @user = User.find_or_create_by_email params[:to]
      # TODO: send email when creating new User
      @transaction = create_transaction(params, (params[:from] == @app[:email] ? 'Authorized' : 'NotAuthorized'))
      # UserMailer.ask_to_authorize_transaction(@transaction).deliver if !@transaction.authorized?
      # TODO: send email when creating an NotAuthorized transaction
      render json: @transaction, status: 200
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

  private
    def check_app_authorization
      true
      @app = Hash.new({:token => "ABCDEF", :email => "tu@merchant.com"})
    end
end
