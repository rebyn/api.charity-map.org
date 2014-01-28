require 'spec_helper'

describe "The API" do
  it "has a root" do
    {:get => "/"}.should route_to(
     :controller => "pages",
     :action => "home"
    )
  end

  it "hits the right controller/action" do
    {:get => "/v1/transactions"}.should route_to(
     :controller => "v1/transactions",
     :action => "index",
     :format => :json
    )
  end
end