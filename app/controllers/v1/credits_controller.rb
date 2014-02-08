module V1
  class CreditsController < ApplicationController
    before_action :auth_using_token

  	def index
  		if (!request.post? && !request.put?)
  			@user = User.find_by_email(params[:email])			
  			if params[:email] && @user
          case @user.category
          when "INDIVIDUAL"
          	@credits = @user.credits
          	@template = 'v1/credits/individual_credits.json.jbuilder'
          when "SOCIALORG"
          	@unprocessed_credits = @user.credits.where("status = ?", "UNPROCESSED")
          	@cleared_credits = @user.credits.where("status = ?", "CLEARED")
          	@template = 'v1/credits/socialorg_credits.json.jbuilder'         	
          end

          respond_to do |format|
            format.json {render(template: @template, status: 200)}
          end
        else
          render json: (params[:email] ? {error: "Email not found"} : {error: "Missing required params[:email]"}), status: 400
        end
  		end
  	end

    def unprocessed      
      if params[:master_transaction_id]
        @credits = Credit.where("status = ? AND master_transaction_id = ?", "UNPROCESSED", params[:master_transaction_id])
        respond_to do |format|
          if @credits
            format.json {render(template: "v1/credits/index", status: 200)}
          else
            render json: {error: "No associated credits"}, status: 400
          end
        end
      else
        render json: {error: "Missing required params[:master_transaction_id]"}, status: 400
      end
    end

    def cleared
      if params[:master_transaction_id]
        @credits = Credit.where("status = ? AND master_transaction_id = ?", "CLEARED", params[:master_transaction_id])
        respond_to do |format|
          if @credits
            format.json {render(template: "v1/credits/index", status: 200)}
          else
            render json: {error: "No associated credits"}, status: 400
          end
        end
      else
        render json: {error: "Missing required params[:master_transaction_id]"}, status: 400
      end
    end

    def pending_clearance
      if params[:master_transaction_id]
        @credits = Credit.joins(:user).where("credits.status = ? AND credits.master_transaction_id = ? AND users.category = ?", "UNPROCESSED", params[:master_transaction_id], "SOCIALORG")
        respond_to do |format|
          if @credits
            format.json {render(template: "v1/credits/index", status: 200)}
          else
            render json: {error: "No associated credits"}, status: 400
          end
        end
      else
        render json: {error: "Missing required params[:master_transaction_id]"}, status: 400
      end
    end
  	
    # def show
  	# 	@user = User.find_by_email(@app.email)
  	# 	if @user && @user.category == "MERCHANT" && params[:id]
  	# 		@credit = Credit.find_by_uid(params[:id])
  	# 		respond_to do |format|
  	#       format.json {render(template: "/credits/detail_credit.json.jbuilder", status: 200)}
  	#     end
  	#   else
  	#   	if @user
  	#   		render json: {error: "Only for MERCHANT accounts"}, status: 400
  	#   	elsif !params[:id]
  	#   		render json: {error: "UUID must not be blank"}, status: 400
  	#   	else
   #      	render json: (params[:email] ? {error: "Email not found"} : {error: "Missing required params[:email]"}), status: 400
   #    	end
   #    end
  	# 	end
  	# end

  	private
      def auth_using_token
        authenticate_or_request_with_http_token do |token, options|
          @token = AuthToken.find_by(value: token)
        end
      end
  end
end