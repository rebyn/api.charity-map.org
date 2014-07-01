module TransactionsHelper
  def check_transaction_prerequisites(sender, recipient, params)
    message = []
    message.push("Required params[:currency].") if !params[:currency]
    message.push("Sender Email Not Found.") if !sender
    message.push("Recipient Email Invalid.")  if !recipient && !(recipient = User.create(email: params[:to]))
    if sender && !sender.is?("MERCHANT") && sender.credits.unprocessed.sum(:amount) < params[:amount].to_f
      message.push("Not Having Enough Credit To Perform The Transaction.")
    elsif sender && recipient
      if recipient.is?("MERCHANT") || (!sender.is?("MERCHANT") && recipient.is?("INDIVIDUAL"))
        message.push("Credits Restricted To Be Sent Only to Organizational Accounts.")
      end
    end
    return message.join(" ")
  end

  def credit_transfer(sender, recipient, transaction)
    @break_down, @sender, @recipient, @transaction = {}, sender, recipient, transaction
    Credit.transaction do
      if @sender.is?("MERCHANT")
        @recipient.credits.create!(master_transaction_id: @transaction.uid, amount: @transaction.amount, currency: @transaction.currency)
        @break_down[@transaction.uid.to_sym] = @transaction.amount
      else
        # MUST NOT REMOVE "!" in below code lines
        @temp_amount = transaction.amount.to_f
        @sender.credits.each do |credit|
          if credit.amount < @temp_amount
            @temp_amount = @temp_amount - credit.amount
            @created_credit = @recipient.credits.create!(master_transaction_id: credit.master_transaction_id, amount: credit.amount, currency: transaction.currency)
            credit.update_attributes!(amount: 0)
            @break_down[credit.master_transaction_id.to_sym] = credit.amount
          elsif credit.amount > @temp_amount
            @created_credit = @recipient.credits.create!(master_transaction_id: credit.master_transaction_id, amount: @temp_amount, currency: transaction.currency)
            credit.update_attributes!(amount: credit.amount - @temp_amount)
            @break_down[credit.master_transaction_id.to_sym] = @temp_amount
            break
          else
            @created_credit = @recipient.credits.create!(master_transaction_id: credit.master_transaction_id, amount: credit.amount, currency: transaction.currency)
            credit.update_attributes!(amount: 0)
            @break_down[credit.master_transaction_id.to_sym] = credit.amount
            break
          end
        end
      end
    end
    return @break_down
  end

  def post_authorize_transaction_job(transaction)
    @transaction = transaction
    if @transaction.authorized?
      @break_down = credit_transfer(@transaction.sender, @transaction.recipient, @transaction)
      @transaction.break_down = @break_down
      @transaction.save!
    end
  end
end
