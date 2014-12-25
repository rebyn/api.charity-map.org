module V1
  class UsersController < ApplicationController
    before_action :authenticate

    def create
      if params && params[:email] && params[:category]
        if @user = User.find_by(email: params[:email])
          respond_to do|format|
            format.json do
              render(template: 'v1/users/show.json.jbuilder',
                     status: 200)
            end
          end
        else
          @user = User.new(email: params[:email], category: params[:category])
          if @user.save
            # UserMailer.send_auth_token(@user).deliver
            render json: { auth_token: @user.auth_token.value }, status: 201
          else
            render json: { error: @user.errors.full_messages.join(' ') }, status: 400
          end
        end
     else
       render json: { error: 'Missing required params' }, status: 400
     end
    end

    def show
      if params[:email]
        if (@user = User.find_by_email(params[:email]))
          respond_to do|format|
            format.json do
              render(template: 'v1/users/show.json.jbuilder',
                     status: 200)
            end
          end
        else
          render json: { error: 'User Not Found' }, status: 400
        end
      else
        render json: { error: 'Missing required params[:email]' }, status: 400
      end
    end

    def update
      if params[:email]
        if (@user = User.find_by_email(params[:email]))
          @user.update_attribute :category, params[:category] if params[:category]
          respond_to do|format|
            format.json do
              render(template: 'v1/users/show.json.jbuilder',
                     status: 200)
            end
          end
        else
          render json: { error: 'User Not Found' }, status: 400
        end
      else
        render json: { error: 'Missing required params[:email]' }, status: 400
      end
    end

    def balance
      if params[:email] && (@user = User.find_by(email: params[:email]))
        @balance = @user.credits.unprocessed.sum(:amount)
        render json: { balance: @balance }, status: 200
      else
        render json: { error: 'Missing required params[:email]' }, status: 400
      end
    end

    protected

    def authenticate
      authenticate_or_request_with_http_token do |token, _options|
        token == ENV['API_CREATE_USER_TOKEN']
      end
    end
  end
end
