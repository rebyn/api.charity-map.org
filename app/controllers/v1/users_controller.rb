module V1
  class UsersController < ApplicationController
    before_action :authenticate

  	def create
      if params && params[:email] && params[:category]
        @user = User.new(email: params[:email], category: params[:category])
        if @user.save
          UserMailer.send_auth_token(@user).deliver
          render json: { auth_token: @user.auth_token.value }, status: 201
        else
          render json: { error: @user.errors.full_messages.join(" ") }, status: 400
        end
      else
        render json: { error: "Missing required params" }, status: 400
      end
    end

    protected
      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          token == "ABCabc"
        end
      end
  end
end