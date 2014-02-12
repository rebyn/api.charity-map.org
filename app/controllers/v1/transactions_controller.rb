module V1
  class TransactionsController < ApplicationController
    before_action :auth_using_token
    include TransactionsHelper
    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

    # DOC: https://github.com/rebyn/api.charity-map.org/blob/master/docs/transactions.md#get-transactions
    def index
      if (!request.post? && !request.put?)
        @user = User.find_by_email(params[:email])
        if params[:email] && @user
          @transactions = Transaction.where(sender_email: params[:email]).authorized
          if @transactions.empty?
            render json: { error: "Transactions Not Found" }, status: 400
          else
            respond_to {|format| format.json {render}}
          end
        else
          render json: (params[:email] ? {error: "Email not found"} : {error: "Missing required params[:email]"}), status: 400
        end
      else # handle PUT/POST
        @sender = User.find_by_email(params[:from])
        @recipient = User.find_by_email(params[:to])
        # TODO: send email when creating new User
        @valid_transaction = check_transaction_prerequisites(@sender, @recipient, params)
        if !@valid_transaction.blank?
          render json: { error: @valid_transaction }, status: 400
        else
          @transaction = create(params,
            (params[:from] == @token.user.email ? 'Authorized' : 'NotAuthorized')
          )
          # UserMailer.ask_to_authorize_transaction(@transaction).deliver if !@transaction.authorized?
          # TODO: send email when creating an NotAuthorized transaction
          # TODO: after authorizing, transfer credits
          # TODO: if @transaction.status == "Authorized"
          post_authorize_transaction_job(@transaction) if @transaction.authorized?
          respond_to do |format|
            format.json {render(template: 'v1/transactions/create.json.jbuilder', status: 201)}
          end
        end
      end
    end

    def authorize
      if params[:token] && (@token = Token.find_by(value: params[:token]))
        if @token.status == 'NEW' && !@token.transaction.authorized?
          @transaction = @token.transaction
          @token.update_attribute :status, 'USED'
          @transaction.update_attribute :status, 'Authorized'
          post_authorize_transaction_job(@transaction) if @transaction.authorized?
          render json: {status: @transaction.status}, status: 200
        end
      else
        render json: {error: "Token not found"}, status: 400
      end
    end

    def show
      if !params[:uid]
        render json: { error: "Required params[:id]." }, status: 400
      else
        @transaction = Transaction.find_by_uid(params[:uid])
        if !@transaction
          render json: { error: "Transaction not found." }, status: 400
        else
          @transactions = Transaction.where("break_down ? :key", :key => @transaction.uid)
          respond_to { |format| format.json {render(template: 'v1/transactions/show.json.jbuilder', status: 200)} }
        end
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

      def auth_using_token
        authenticate_or_request_with_http_token do |token, options|
          @token = AuthToken.find_by(value: token)
        end
      end
  end
end