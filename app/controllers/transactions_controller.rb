class TransactionsController < ActionController::API
	include ActionController::MimeResponds

	def index
	  @transactions = Transaction.all
	    
	  respond_to do |format|
	    format.json { render json: @transactions }
	  end
	end

	def new
		transaction = Transaction.new
		transaction.amount = 200
		transaction.created_at = Time.now.to_datetime
		transaction.save
		die
	end

	def create
		@transaction = Transaction.new(params[:transaction])
		@transaction.created_at = Time.now.to_datetime
		if @transaction.save 
			respond_to do |format|
    		format.json { render json: @transaction }
  		end
  	else
  		respond_to do |format|
    		format.json { render json: @transaction }
  		end
		end
	end

	def authorize
		token_value = params[:token]
		transaction_id = params[:transaction_id]
		transaction = Transaction.where("id = ? AND uid = ?", transaction_id, token_value).first

		if transaction
			transaction.update_attributes(status: 'authorized')
		end
	end
end
