if @transactions.empty?
  json.message "Transactions Not Found"
else
  json.array! @transactions do |transaction|
    json.uid transaction.uid
    json.from transaction.sender_email
    json.to transaction.recipient_email
    json.amount transaction.amount
    json.currency transaction.currency
    json.references transaction.references
    json.status transaction.status
    json.(transaction, :created_at)        
  end
end
