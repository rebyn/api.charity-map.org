if !@unprocessed_credits && !@cleared_credits
	json.message "There were no credits of this user"
else
	json.UNPROCESSED @unprocessed_credits do |credit|
		json.uid credit.uid
        json.amount credit.amount
        json.currency credit.currency
        json.merchant credit.merchant do |m|
            json.email m.email
            json.name  m.name
            json.contact m.contact
        end
    end
    json.CLEARED @cleared_credits do |credit|
        json.uid credit.uid
        json.amount credit.amount
        json.currency credit.currency
        json.merchant credit.merchant do |m|
            json.email m.email
            json.name  m.name
            json.contact m.contact
        end
    end
end