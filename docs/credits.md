Credits
========


Get credits
------------

```shell
curl -H 'Authorization: Token token=YOUR_APP_TOKEN' https://api.charity-map.org/v1/credits.json?email=QUERIED_EMAIL
```

* `GET /credits.json` will return all active credits.

**For MERCHANT account:**

```json
[
  {
    "uuid": 6058166321,
    "transaction_id": 1234567890,
    "to": "u2@yahoo.net",
    "amount": 500000,
    "currency": "VND",
    "description": "Cimigo / Survey on Cocacola",
    "created_at": "2014-03-23T13:55:43-05:00",
    "url": "https://api.charity-map.org/v1/credits/6058166321.json"
  },
  {
    "uuid": 1058166328,
    "transaction_id": 2234567894,
    "to": "u1@gmail.com",
    "amount": 250000,
    "currency": "VND",
    "description": "MixUp - November giftcard",
    "created_at": "2014-03-23T13:55:43-05:00",
    "url": "https://api.charity-map.org/v1/credits/1058166328.json"
  }
]
```

**For INDIVIDUAL account:**

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
      }
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
      }
    },
    {
      "uuid": 1234567890,
      "amount": 150000,
      "currency": "VND",
      "merchant": {
        "email": "merchant@gmail.com",
        "name": "PwC Vietnam",
        "contact": "5 Mac Dinh Ky HCMC, Vietnam 082930198392"
      }
    }
  ]
}
```

Get credit
-----------

* `GET /credits/6058166321.json` will return the specified credit.

Note: Only for **MERCHANT** accounts.

```json
{
  "uuid": 6058166321,
  "transaction_id": 1234567890,
  "to": "u2@yahoo.net",
  "amount": 500000,
  "currency": "VND",
  "description": "MixUP - November giftcard",
  "created_at": "2014-03-23T13:55:43-05:00",
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

Create and Update Credit
---------------

Credits are created, transfered and cleared together with transactions. These actions are not supported.