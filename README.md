The Giving API: [api.charity-map.org](https://api.charity-map.org)
====================

**Note**: This is the first version of the Charity Map API (at [api.charity-map.org](https://api.charity-map.org)). The system is in active development and will go through radical changes starting 01/2014. It's recommended you read through our documentation and changelogs, and leverage the existing wrappers that we support (currently: in Ruby).

Register your app
----------------

Most of the transactions on `api.charity-map.org` are credit transfers between merchants, individuals and charities. If you're a merchant (we define `merchant` as an entity that sends out credit to individuals, i.e: a company that gives gift card, or compensates its users for their work like filling a survey, or sends credit to employees in their annual charity program), you need to register (to us) your usage and obtain a token.

Register your app and obtain a token at [https://api.charity-map.org/apps](https://api.charity-map.org/apps)


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
  -H 'Authorization: Token token=YOUR_APP_TOKEN' \
  -d '{ "from": "u1@gmail.com", "to": "u2@gmail.com", "amount": 100000, "references": "Donation #93821243 on charity-map.org" }' \
  https://api.charity-map.org/v1/transactions
```


Authorization
--------------

`api.charity-map.org` authorizes transactions via email. However, in order to create transactions, you need to register your app and obtain an app token (default transaction status will be `NotAuthorized`, and users will have to authorize the transaction via their emails)


Identify your app
-----------------

You must include a `Authorization` header with the token of your application:

    Authorization: Token token=YOUR_APP_TOKEN

If you don't supply this header, you will get a `401 Access Denied` response.


No XML, just JSON
-----------------

We only support JSON for serialization of data. Our format is to have no root element and we use snake\_case to describe attribute keys. This means that you have to send `Content-Type: application/json; charset=utf-8` when you're POSTing or PUTing data into the API. **All API URLs end in .json to indicate that they accept and return JSON.**

You'll receive a `415 Unsupported Media Type` response code if you attempt to use a different URL suffix or leave out the `Content-Type` header.


Handling errors
---------------





API ready for use
-----------------

* [Transactions](https://github.com/rebyn/api.charity-map.org/blob/master/docs/transactions.md)
* [Credits](https://github.com/rebyn/api.charity-map.org/blob/master/docs/credits.md)



<!-- API libraries
-------------

* [charity_map](https://rubygems.org/gems/charity_map) - Ruby gem -->

Help us make it better
----------------------

Please tell us how we can make the API better. If you have a specific feature request or if you found a bug, please use GitHub issues. Fork these docs and send a pull request with improvements.

To talk with us and other developers about the API, shoot us an email at [dev@charity-map.org](mailto:dev@charity-map.org)