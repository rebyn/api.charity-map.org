module V1
  class UsersController < ApplicationController
    before_action :authenticate

  	def create
      if params && params[:email] && params[:category]
        @user = User.create(email: params[:email], category: params[:category])
        if @user
          # TODO: UserMailer.send_auth_token(@user)
          render json: { "auth_token" => @user.auth_token.value }, status: 200 
        else
          render json: { "error" => "Cannot create user" }, status: 400
        end
      else
        render json: { "error" => "Cannot create user" }, status: 400
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