module V1
  class CreditsController < ApplicationController
  	before_action :auth_using_token
    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  	def index
      if !params[:master_transaction_id].blank? || !params[:email].blank?

        if !params[:email].blank? && @user = User.find_by_email(params[:email])
          @credits = @user.credits
        elsif !params[:master_transaction_id].blank?
          @credits = Credit.where(master_transaction_id: params[:master_transaction_id])
        end

        @credits = @credits.where(status: params[:status].capitalize) if !@credits.empty? && !params[:status].blank?

        if @credits && @credits.empty?
          render json: { error: "No associated credits"}, status: 400
        else
          respond_to {|format| format.json {render(template: "v1/credits/index", status: 200)}}
        end
      else
        render json: {error: "Missing required params[:email] or params[:master_transaction_id]"}, status: 400
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