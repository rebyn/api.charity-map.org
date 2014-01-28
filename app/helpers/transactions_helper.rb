module TransactionsHelper
  def credit_transfer(sender, recipient, transaction)
    break_down, @sender, @recipient, @transaction = [], sender, recipient, transaction
    if @sender.is_merchant?
      @recipient.credits.create(master_transaction_id: @transaction.uid, amount: @transaction.amount, currency: @transaction.currency)            
      @break_down.push({ @transaction.uid.to_sym => @transaction.amount })
    else
      # MUST NOT REMOVE "!" in below code lines
      @temp_amount = transaction.amount.to_f
      @sender.credits.each do |credit|
        if credit.amount < @temp_amount
          @temp_amount = @temp_amount - credit.amount
          @created_credit = @recipient.credits.create!(master_transaction_id: credit.master_transaction_id, amount: credit.amount, currency: transaction.currency)
          credit.update_attributes!(amount: 0)
          break_down.push({credit.master_transaction_id.to_sym => credit.amount})
        elsif credit.amount > @temp_amount
          @created_credit = @recipient.credits.create!(master_transaction_id: credit.master_transaction_id, amount: @temp_amount, currency: transaction.currency)
          credit.update_attributes!(amount: credit.amount - @temp_amount)
          break_down.push({credit.master_transaction_id.to_sym => @temp_amount})
          break
        else
          @created_credit = @recipient.credits.create!(master_transaction_id: credit.master_transaction_id, amount: credit.amount, currency: transaction.currency)
          credit.update_attributes!(amount: 0)
          break_down.push({credit.master_transaction_id.to_sym => credit.amount})
          break
        end
      end
    end
    return @break_down
  end
end
