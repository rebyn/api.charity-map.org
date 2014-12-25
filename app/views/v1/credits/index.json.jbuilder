json.array! @credits do |credit|
  json.transaction_id credit.master_transaction_id
  json.uid credit.uid
  json.email credit.user.email
  json.amount credit.amount
  json.currency credit.currency
  json.created_at credit.created_at
  json.status credit.status
end
