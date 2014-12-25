require 'spec_helper'

describe V1::PagesController do
  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
    request.env['HTTPS'] = 'on'
  end

  it 'should link to documentation on :root' do
    get :home
    expect(response.status).to eq(200)
    expect(response.body).to eq(
      { documentation: 'https://github.com/rebyn/api.charity-map.org' }.to_json)
  end
end
