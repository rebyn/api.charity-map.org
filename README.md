The Giving API: [api.charity-map.org](https://api.charity-map.org)
====================

**Note**: This is the first version of the Charity Map API (at [api.charity-map.org](https://api.charity-map.org)). The system is in active development and will go through radical changes starting 01/2014. It's recommended you read through our documentation and changelogs, and leverage the existing wrappers that we support (currently: in Ruby).


Making a request
----------------

All URLs start with `https://api.charity-map.org/v1/`. **SSL only**. The path is prefixed with the API version. If we change the API in backward-incompatible ways, we'll bump the version marker and maintain stable support for the old URLs.

**Example:** To make a request for credits associated with an email address:

```shell
curl -H 'User-Agent: YOUR_APP_TOKEN' https://api.charity-map.org/v1/credit?email=QUERIED_EMAIL
```

To create a transaction (to transfer credit or to donate), it's the same deal except you also have to include the `Content-Type` header and the JSON data:

```shell
curl -H 'Content-Type: application/json' \
  -H 'User-Agent: YOUR_APP_TOKEN' \
  -d '{ "from": "u1@gmail.com", "to": "u2@gmail.com", "amount": 100000, "extra": "Donation #93821243 on charity-map.org" }' \
  https://api.charity-map.org/v1/transactions.json
```


Authentication
--------------

If you're making a private integration with Basecamp for your own purposes, you can use HTTP Basic authentication. This is secure since all requests in the new Basecamp use SSL.

If you're making a public integration with Basecamp for others to enjoy, you must use OAuth 2. This allows users to authorize your application to use Basecamp on their behalf without having to copy/paste API tokens or touch sensitive login info.

Read the [authentication guide](https://github.com/37signals/api/blob/master/sections/authentication.md) to get started.


Identify your app
-----------------

You must include a `User-Agent` header with the token of your application:

    User-Agent: YOUR_APP_TOKEN

If you don't supply this header, you will get a `400 Bad Request` response.


No XML, just JSON
-----------------

We only support JSON for serialization of data. Our format is to have no root element and we use snake\_case to describe attribute keys. This means that you have to send `Content-Type: application/json; charset=utf-8` when you're POSTing or PUTing data into the API. **All API URLs end in .json to indicate that they accept and return JSON.**

You'll receive a `415 Unsupported Media Type` response code if you attempt to use a different URL suffix or leave out the `Content-Type` header.

Use HTTP caching
----------------

You must make use of the HTTP freshness headers to lessen the load on our servers (and increase the speed of your application!). Most requests we return will include an `ETag` or `Last-Modified` header. When you first request a resource, store this value, and then submit them back to us on subsequent requests as `If-None-Match` and `If-Modified-Since`. If the resource hasn't changed, you'll see a `304 Not Modified` response, which saves you the time and bandwidth of sending something you already have.


Handling errors
---------------

If the API is having trouble, you might see a 5xx error. `500` means that the app is entirely down, but you might also see `502 Bad Gateway`, `503 Service Unavailable`, or `504 Gateway Timeout`. It's your responsibility in all of these cases to retry your request later. 


Rate limiting
-------------

You can perform up to 500 requests per 10 second period from the same IP address for the same account. If you exceed this limit, you'll get a [429 Too Many Requests](http://tools.ietf.org/html/draft-nottingham-http-new-status-02#section-4) response for subsequent requests. Check the `Retry-After` header to see how many seconds to wait before retrying the request.



API ready for use
-----------------

* [Projects](https://github.com/37signals/bcx-api/blob/master/sections/projects.md)




API libraries
-------------

* [Logan](https://rubygems.org/gems/logan) - Ruby gem

Help us make it better
----------------------

Please tell us how we can make the API better. If you have a specific feature request or if you found a bug, please use GitHub issues. Fork these docs and send a pull request with improvements.

To talk with us and other developers about the API, shoot us an email at [team@charity-map.org](mailto:team@charity-map.org)