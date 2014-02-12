module V1
  class UsersController < ApplicationController
    before_action :authenticate

  	def create
      if params && params[:email] && params[:category]
        @user = User.new(email: params[:email], category: params[:category])
        if @user.save
          # UserMailer.send_auth_token(@user).deliver
          render json: { auth_token: @user.auth_token.value }, status: 201
        else
          render json: { error: @user.errors.full_messages.join(" ") }, status: 400
        end
      else
        render json: { error: "Missing required params" }, status: 400
      end
    end

    def balance
      if params[:email] && (@user = User.find_by(email: params[:email]))
        @balance = @user.credits.unprocessed.sum(:amount)
        render json: {balance: @balance}, status: 200
      else
        render json: { error: "Missing required params[:email]" }, status: 400
      end
    end

    protected
      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          token == ENV['API_CREATE_USER_TOKEN']
        end
      end
  end
end