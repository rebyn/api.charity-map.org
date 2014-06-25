# Before do
#   FakeWeb.clean_registry
#   FakeWeb.allow_net_connect = %r[^https?://127.0.0.1]
#   FakeWeb.register_uri(:get,
#     %r|http://maps.googleapis\.com/|,
#     :body => "Hello World!")
# end