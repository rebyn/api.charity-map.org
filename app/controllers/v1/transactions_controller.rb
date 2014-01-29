module V1
  class TransactionsController < ApplicationController
    before_filter :check_app_authorization
    include TransactionsHelper

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
        @sender = User.find_by_email(params[:from])
        @recipient = User.find_by_email(params[:to])
        # TODO: send email when creating new User
        @valid_transaction = check_transaction_prerequisites(@sender, @recipient, params)
        if !@valid_transaction.blank?
          render json: { "error" => @valid_transaction }, status: 400
        else
          @transaction = create(params,
            (params[:from] == @app[:email] ? 'Authorized' : 'NotAuthorized')
          )
          # UserMailer.ask_to_authorize_transaction(@transaction).deliver if !@transaction.authorized?
          # TODO: send email when creating an NotAuthorized transaction
          # TODO: after authorizing, transfer credits
          # TODO: if @transaction.status == "Authorized"          
          @break_down = credit_transfer(@sender, @recipient, @transaction)          
          @transaction.break_down = @break_down
          @transaction.save!          
          respond_to do |format|
            format.json {render(template: 'v1/transactions/create.json.jbuilder', status: 200)}
          end
        end
      end
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

    def check_transaction_prerequisites(sender, recipient, params)
      message = []
      message.push("Required params[:currency].") if !params[:currency]
      message.push("Sender Email Not Found.") if !sender
      message.push("Recipient Email Not Found.") if !recipient
      if sender && !sender.is_merchant? && sender.credits.unprocessed.sum(:amount) < params[:amount].to_f
        message.push("Not Having Enough Credit To Perform The Transaction.")
      elsif sender && recipient
        if recipient.is_merchant? || (!sender.is_merchant? && recipient.is_individual?)
          message.push("Credits Restricted To Be Sent Only to Organizational Accounts.")
        end
      end
      return message.join(" ")
    end

    def show
      @message = []      
      if params[:id]
        @transaction = Transaction.find_by_uid(params[:id])
        @user = User.find_by_email(@app[:email])
        @message.push("Transaction does not belong to you.") if @app[:email] != @transaction.sender_email
      end            
      @message.push("Required params[:id].") if !params[:id]
      @message.push("There was no transaction.") if !@transaction
      @message.push("Only for MERCHANT and ORGANIZATION account.") if !@user || @user.category == "INDIVIDUAL"      
      @message.join(" ")
      if !@message.blank?
        render json: {"error" => @message}, status: 400
        return false        
      end
      @transactions = Transaction.where("break_down ? '#{@transaction.uid}'")
      respond_to do |format|
        format.json {render(template: 'v1/transactions/detail.json.jbuilder', status: 200)}
      end
    end

    private
      def create(params, status)
        @transaction = Transaction.create(
          sender_email: params[:from], recipient_email: params[:to],
          amount: params[:amount], currency: params[:currency],
          references: params[:references]
        )
        @transaction.update_attribute(:status, status) if (status == 'Authorized')
        return @transaction
      end

      def check_app_authorization
        true
        @app = {:token => "ABCDEF", :email => "merchant@company.com"}
      end
  end
end