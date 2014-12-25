unless @transactions.empty?
  json.array! @transactions do |transaction|
    json.uid transaction.uid
    json.from transaction.sender_email
    json.to transaction.recipient_email
    json.amount transaction.amount
    json.currency transaction.currency
    json.references transaction.references
    json.status transaction.status
    json.break_down transaction.break_down
    json.call(transaction, :created_at)
  end
end
