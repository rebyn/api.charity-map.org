class TransactionsController < ActionController::API
	include ActionController::MimeResponds

	def index
	  @transactions = Transaction.all
	    
	  respond_to do |format|
	    format.json { render json: @transactions }
	  end
	end

	def new
	end

	def create
		@transaction = Transaction.new(params[:transaction])
		@transaction.created_at = Time.now
		if @transaction.save
			token = Token.new
			token.transaction_id = @transaction.uid
			# expired 4 days later
			token.expiry_date = Time.now.midnight + 4.days			
			if token.save
				respond_to do |format|
    			format.json { render json: @transaction }
  			end
  		end
  	else
  		# do something
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
end
