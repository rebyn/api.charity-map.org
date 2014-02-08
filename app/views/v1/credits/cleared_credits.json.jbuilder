json.CLEARED @credits do |credit|
	json.uuid credit.uid
  json.amount credit.amount
  json.currency credit.currency
  json.created_at credit.created_at
  json.status credit.status   
end
