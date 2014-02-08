if !@credits || @credits.empty?
    json.message "There were no credits of this user"
else
  json.array! @credits do |credit|
    json.uid credit.uid
    json.email credit.user.email
    json.amount credit.amount
    json.currency credit.currency    
  end
end