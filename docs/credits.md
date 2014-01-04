Credits
========


Get credits
------------

* `GET /credits.json` will return all active credits.

**For MERCHANTS:**

```json
[
  {
    "uuid": 6058166321,
    "transaction_id": 1234567890,
    "to": "u2@yahoo.net",
    "amount": 500000,
    "currency": "VND",
    "description": "The Next Generation",
    "created_at": "2012-03-23T13:55:43-05:00",
    "url": "https://api.charity-map.org/v1/credits/6058166321.json"
  },
  {
    "id": 684146117,
    "name": "Nothing here!",
    "description": null,
    "updated_at": "2012-03-22T16:56:51-05:00",
    "url": "https://api.charity-map.org/v1/credits/684146117-nothing-here.json",
    "archived": false,
    "starred": false
  }
]
```

**For INDIVIDUAL:**

```json
{
  "uuid": 1234567890,
  "email": "u1@gmail.com",
  "amount": 500000,
  "currency": "VND"
}
```

**For ORGANIZATIONS:**

```json
{
  "UNPROCESSED": [
    {
      "uuid": 1234567890,
      "amount": 500000,
      "currency": "VND",
      "merchant": {
        "email": "merchant@gmail.com",
        "name": "PiA Vietnam",
        "contact": "01 Pasteur, Saigon, Vietnam 082930198392"
      },
    }
  ],
  "CLEARED": [
    {
      "uuid": 1234567890,
      "amount": 250000,
      "currency": "VND",
      "merchant": {
        "email": "merchant@gmail.com",
        "name": "PiA Vietnam",
        "contact": "01 Pasteur, Saigon, Vietnam 082930198392"
      },
    }
  ]
}
```

Get credit
-----------

* `GET /credits/1.json` will return the specified credit.

```json
{
  "uuid": 6058166321,
  "transaction_id": 1234567890,
  "to": "u2@yahoo.net",
  "amount": 500000,
  "currency": "VND",
  "description": "The Next Generation",
  "created_at": "2012-03-23T13:55:43-05:00",
  "break_down": {
    "unprocessed": {
      "organizations": [
        {
          "name": "Chia Se Yeu Thuong",
          "email": "chiaseyeuthuong@gmail.com",
          "payment_info": "ACB 1234567890 Nguyen Van A",
          "amount": 250000,
          "currency": "VND"
        }
      ],
      "individual": [
        {
          "email": "u2@yahoo.net",
          "amount": 100000,
          "currency": "VND"
        }
      ]
    },
    "cleared": [
      {
        "name": "Thien Nguyen Group",
        "email": "nhomthiennguyen@gmail.com",
        "payment_info": "TCB 1234567890 Tran Van B",
        "amount": 150000,
        "currency": "VND"
      }
    ]
  }
}
```

Create, Update, delete credit
---------------

Credits are created, transfered, and cleared together with transactions. These actions are not supported.