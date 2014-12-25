require 'spec_helper'

describe 'The API' do
  it 'has a root' do
    { get: '/' }.should route_to(
     controller: 'pages',
     action: 'home'
    )
  end

  it 'hits the right Transaction controller/action' do
    { get: '/v1/transactions' }.should route_to(
     controller: 'v1/transactions',
     action: 'index',
     format: :json
    )

    { post: '/v1/transactions' }.should route_to(
     controller: 'v1/transactions',
     action: 'index',
     format: :json
    )
  end

  it 'fetchs for a specific transaction' do
    { get: '/v1/transactions/123456' }.should route_to(
     controller: 'v1/transactions',
     action: 'show',
     uid: '123456',
     format: :json
    )
  end
end
