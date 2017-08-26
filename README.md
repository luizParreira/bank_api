# Bank API

## Set up

### Docker (recommended)

If you are on Linux, install docker for Linux:
- https://docker.github.io/engine/installation/

If you are on MacOS, install Docker-Compose, VirtualBox, docker-machine and NFS.
- `brew install docker-compose`
- https://www.virtualbox.org/wiki/Downloads
- https://docs.docker.com/machine/install-machine/
- Run `docker-machine create default --driver virtualbox --virtualbox-memory "3072"`, to create a VM.
- Run `eval $(docker-machine env)`
- Install NFS https://github.com/adlogix/docker-machine-nfs

### Building the project

1. Give execute permissions to the start script: `chmod +x script/start.sh` (from the project's root)
2. Run `docker-compose build`
3. Once the project is built, run `docker-compose up`
4. Once it finishes compiling and bringing the app up, you should be able to access the app on:
  - Run: `docker-machine ip`
  - You should be able to access the app by routing to the docker-machine ip printed from the command above. For example, `http://192.168.99.100:4000`.
  - Or you might have already mapped this locally to `localhost` or `dev`. For example, `http://localhost:4000` or `http://dev:4000`.

### Locally

You will need to have all these dependencies installed (You may want to follow the installation guide on https://hexdocs.pm/phoenix/installation.html):

- Elixir installed
- Mix installed
- Phoenix Framework
- Postgres

Once you have installed it, you should:

1. Give permission to the script to execute `chmod +x script/start.sh`.
2. Run the script `./script/start.sh`


### Seeding data

When you run `docker-compose up` or `./script/start.sh` a script on `/priv/repo/seeds.exs` will run and initially populate the database.


# Bank API

The solution proposed to the exercise is to create a `checking_accounts` table. That is associated with a `transactions` table, this table persists the operations made by the `credit` and `debit` operations.

## Operations API

### Credit

Creates a credit transaction to the users account
```
POST /api/v1/checking_account/:checking_account_id/credit/:amount
```
#### Parameters

- checking_account_id (Integer) - Users account id
- amount (Float) - Amount to credit
- description (string) - Description of transaction
- date (UTC Timestamp) - Amount to credit

#### Status

- 200
- 404
- 400

#### Example
`POST /api/v1/checking_account/1/credit/100.0?description=payment+from+jow&date=1503704316`
```javascript
{
  "data": "success"
}
```

### Debit

Creates a debit (negative `amount`) transaction to the users account.
```
POST /api/v1/checking_account/:checking_account_id/debit/:amount
```
#### Parameters

- checking_account_id (Integer) - Users account id
- amount (Float) - Amount to credit
- description (string) - Description of transaction
- date (UTC Timestamp) - Amount to credit

#### Status

- 200
- 404
- 400

#### Example
`POST /api/v1/checking_account/1/credit/100.0?description=buy+book&date=1503704316`
```javascript
{
  "data": "success"
}
```

### Balance

Returns the sum of `amount` over all transactions created for this user
```
GET /api/v1/checking_account/:checking_account_id/balance
```
#### Parameters

- checking_account_id (Integer) - Users account id

#### Status

- 200
- 404

#### Example
`GET /api/v1/checking_account/1/balance`
```javascript
{
  "data": {
    "balance": 123.0
  }
}
```

### Bank Statement

Returns the bank statement regarding the given checking account. Given optional start and end date. If `start_date` and `end_date` are not given, statement for all transactions will return.
```
GET /api/v1/checking_account/:checking_account_id/statement
```
#### Parameters

- checking_account_id (Integer) - Users account id
- start_date (UTC Timestamp or YYYY-MM-DD) - start date of the statement
- end_date (UTC Timestamp or YYYY-MM-DD) - end date of the statement

#### Status

- 200
- 404
- 400

#### Example
`GET /api/v1/checking_account/1/statement`
```javascript
{
  "data": [
    {
      "balance": 123.0,
      "date": "2017-08-25",
      "transactions": [
        {
          "description": "a description",
          "amount" : "1204",
          "ts" : 1234556
        },
        {
          "description": "Another description",
          "amount" : "-14.0",
          "ts" : 1234523
        }
      ]
    }
  ]
}
```

### Periods of Debt

Returns all the periods in which the given user was on debt.

```
GET /api/v1/checking_account/:checking_account_id/periods_of_debt
```
#### Parameters

- checking_account_id (Integer) - Users account id

#### Status

- 200
- 404

#### Example
`GET /api/v1/checking_account/1/periods_of_debt`
```javascript
{
  "data": [
    {
      "start": "2017-08-01",
      "end": "2017-08-04",
      "principal" : "120.0"
    },
    {
      "start": "2017-08-20",
      "end": null,
      "principal" : "120.0"
    }
  ]
}
```
