require 'spec_helper'

describe "The API" do
  it "hits the right controller/action" do
    {:get => "/transactions"}.should route_to(
     :controller => "transactions",
     :action => "index",
     :format => :json
    )
  end
end