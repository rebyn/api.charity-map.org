if @credits && @credits.empty?
  json.message "No associated credits"
else
  json.array! @credits do |credit|
  	json.uid credit.uid
    json.user_uid credit.user_id
    json.master_transaction_id credit.master_transaction_id
    json.amount credit.amount
    json.currency credit.currency
    json.created_at credit.created_at
    json.status credit.status   
  end
end