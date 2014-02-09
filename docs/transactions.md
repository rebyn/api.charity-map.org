Transactions
========

Create transaction
--------------

It's quite simple to create a transaction:

* `POST /transactions.json` will create a new transaction from the parameters passed (`PUT` works as well).

```json
{
  "from": "sender@email.net",
  "to": "recipient@email.net",
  "amount": "500000",
  "currency": "VND",
  "references": "Donation #12345 for Children With Happiness project"
}
```

This will return `201 Created`, with the current JSON representation of the transaction if the creation was a success. See the **Get transaction** endpoint for more info. **Note:** If the user hasn't yet agreed to authorize the transaction (by not clicking the link in the email being sent to him/her), you'll see `"status": "NotAuthorized"`.

For merchants who are sending out credits to individuals, you must include a `User-Agent` header with the token of your application:

    Authorization: Token token=YOUR_APP_TOKEN

If you don't supply this header, you will have to authorize manually for these transactions by clicking the link in the email being sent to your address.


Get transactions
------------

* `GET /transactions.json` will return all active transactions.

**For MERCHANT and ORGANIZATION account**:

```json
[
  {
    "uuid": 6058166321,
    "from": "u1@gmail.com",
    "to": "u2@yahoo.net",
    "amount": 500000,
    "currency": "VND",
    "references": "Cimigo / Survey on Cocacola",
    "created_at": "2014-03-23T13:55:43-05:00",
    "url": "https://api.charity-map.org/v1/transactions/6058166321.json"
  },
  {
    "uuid": 2058166323,
    "from": "u1@gmail.com",
    "to": "u3@hotmail.com",
    "amount": 250000,
    "currency": "VND",
    "references": "MixUP / November giftcard",
    "created_at": "2014-03-23T13:55:43-05:00",
    "url": "https://api.charity-map.org/v1/transactions/2058166323.json"
  }
]
```

**For INDIVIDUAL account**:
```json
[
  {
    "uuid": 6058166321,
    "from": "u1@gmail.com",
    "to": "u2@yahoo.net",
    "amount": 500000,
    "currency": "VND",
    "references": "Donation #10293 to Chia Se Yeu Thuong",
    "created_at": "2014-03-23T13:55:43-05:00"
  },
  {
    "uuid": 2058166323,
    "from": "u1@gmail.com",
    "to": "u3@hotmail.com",
    "amount": 250000,
    "currency": "VND",
    "references": "Donation #182739 to Mai Am Tinh Xuan",
    "created_at": "2014-03-23T13:55:43-05:00"
  }
]
```

Note: there are no "url" fields for transactions from an individual account.

Get transaction
-----------

* `GET /transactions/6058166321.json` will return the specified transaction.

Note: Only for **MERCHANT** and **ORGANIZATION** accounts.

```json
{
  "uuid": 6058166321,
  "from": "u1@gmail.com",
  "to": "u2@yahoo.net",
  "amount": 500000,
  "currency": "VND",
  "references": "Donation #10293 to Chia Se Yeu Thuong",
  "created_at": "2014-03-23T13:55:43-05:00"
}
```

Update and Delete Transactions
---------------

These actions are not supported.