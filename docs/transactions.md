Transactions
========

> Operations keeps the lights on, strategy provides a light at the end of the tunnel, 
> but project management is the train engine that moves the organization forward - Joy Gumz


Get transactions
------------

* `GET /transactions.json` will return all active transactions.


```json
[
  {
    "uuid": 6058166321,
    "from": "u1@gmail.com",
    "to": "u2@yahoo.net",
    "name": "BCX",
    "description": "The Next Generation",
    "updated_at": "2012-03-23T13:55:43-05:00",
    "url": "https://api.charity-map.org/v1/transactions/605816632-bcx.json",
    "archived": false,
    "starred": true
  },
  {
    "id": 684146117,
    "name": "Nothing here!",
    "description": null,
    "updated_at": "2012-03-22T16:56:51-05:00",
    "url": "https://api.charity-map.org/v1/transactions/684146117-nothing-here.json",
    "archived": false,
    "starred": false
  }
]
```


Get transaction
-----------

* `GET /transactions/1.json` will return the specified transaction.

```json
{
  "id": 605816632,
  "name": "BCX",
  "description": "The Next Generation",
  "archived": false,
  "created_at": "2012-03-22T16:56:51-05:00",
  "updated_at": "2012-03-23T13:55:43-05:00",
  "starred": true,
  "creator": {
    "id": 149087659,
    "name": "Jason Fried",
    "avatar_url": "https://asset0.37img.com/global/4113d0a133a32931be8934e70b2ea21efeff72c1/avatar.96.gif?r=3"
  },
  "accesses": {
    "count": 5,
    "updated_at": "2012-03-23T13:55:43-05:00",
    "url": "https://api.charity-map.org/v1/transactions/605816632-bcx/accesses.json"
  },
  "attachments": {
    "count": 0,
    "updated_at": null,
    "url": "https://api.charity-map.org/v1/transactions/605816632-bcx/attachments.json"
  },
  "calendar_events": {
    "count": 3,
    "updated_at": "2012-03-22T17:35:50-05:00",
    "url": "https://api.charity-map.org/v1/transactions/605816632-bcx/calendar_events.json"
  },
  "documents": {
    "count": 0,
    "updated_at": null,
    "url": "https://api.charity-map.org/v1/transactions/605816632-bcx/documents.json"
  },
  "topics": {
    "count": 2,
    "updated_at": "2012-03-22T17:35:50-05:00",
    "url": "https://api.charity-map.org/v1/transactions/605816632-bcx/topics.json"
  },
  "todolists": {
    "remaining_count": 4,
    "completed_count": 0,
    "updated_at": "2012-03-23T12:59:23-05:00",
    "url": "https://api.charity-map.org/v1/transactions/605816632-bcx/todolists.json"
  }
}
```


Create transaction
--------------

* `POST /transactions.json` will create a new transaction from the parameters passed.

```json
{
  "from": "sender@email.net",
  "to": "recipient@email.net",
  "amount": "500000"
}
```

This will return `201 Created`, with the current JSON representation of the transaction if the creation was a success. See the **Get transaction** endpoint for more info. **Note:** If the user hasn't yet agreed to authorize for the transaction, you'll see `"status": "NotAuthorized"`.


Update, delete transaction
---------------

These actions are not supported.