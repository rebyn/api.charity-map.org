class PagesController < ActionController::Base
  def home
    render json: { documentation: 'https://github.com/rebyn/api.charity-map.org' }, status: 200
  end
end
