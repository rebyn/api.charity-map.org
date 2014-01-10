# == Schema Information
# 
# Table name: credits
#
# id                   				:integer          not null, primary key
# master_tranasction_id				:string
# amount			 								:double
# belongs_to					 				:integer
# status							 				:string 					{new, unprocessed, cleared}
# created_at									:datetime
# update_at										:datetime
#

class Credit < ActiveRecord::Base
	attr_accessible :id, :master_tranasction_id, :amount, :belongs_to, :status

	validates :id, :master_tranasction_id, :amount, :belongs_to, :status, presence: true
	validates :amount, :numericality => true
	
	belongs_to :transaction

end
