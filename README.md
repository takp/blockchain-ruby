# blockchain-ruby

A simple Blockchain implementation in Ruby.

You can simulate the blockchain with less than __200 lines of code__.

## Concept

This is made based on this article [Learn Blockchains by Building One
](https://hackernoon.com/learn-blockchains-by-building-one-117428612f46).

## Versions

- Ruby 2.5.0

## Run

- Install gems

```bash
$ bundle install
```

- Run

```bash
$ bundle exec ruby blockchain.rb
[2018-01-09 21:49:25] INFO  WEBrick 1.4.2
[2018-01-09 21:49:25] INFO  ruby 2.5.0 (2017-12-25) [x86_64-darwin16]
== Sinatra (v2.0.0) has taken the stage on 4567 for development with backup from WEBrick
[2018-01-09 21:49:25] INFO  WEBrick::HTTPServer#start: pid=12067 port=4567
```

## Interacting with this Blockchain

- Display current blockchain

```bash
$ curl http://localhost:4567/chain

{
  "chain":[
    {
      "index":1,
      "timestamp":"2018-01-09 21:59:51 +0700",
      "transactions":[],
      "proof":1,
      "previous_hash":100
    }
  ],
  "length":1
}
```

- Mining a block

```bash
$ curl http://localhost:4567/mine

{
  "message":"New Block Forged",
  "index":2,
  "transactions":[
    {
      "sender":"0",
      "recipient":"caedf4a87f7841838061dd7dffca2916",
      "amount":1
    }
  ],
  "proof":94813,
  "previous_hash":"84e609b88e68764ac4546cb807d7cf0e"
}
```

- Create a new transaction by making a `POST` request to `/transactions/new`

```bash
$ curl -X POST -H "Content-Type: application/json" -d '{
 "sender": "d4ee26eee15148ee92c6cd394edd974e",
 "recipient": "someone-other-address",
 "amount": 5
}' "http://localhost:4567/transactions/new"

{
  "message":"Transaction will be added to Block 3"
}
```

- Mine 1 block and Display current blockchain again

```bash
$ curl http://localhost:4567/mine
{
  "message":"New Block Forged",
  "index":3,
  "transactions":[
    {
      "sender":"d4ee26eee15148ee92c6cd394edd974e",
      "recipient":"someone-other-address",
      "amount":5
    },
    {
      "sender":"0",
      "recipient":"caedf4a87f7841838061dd7dffca2916",
      "amount":1
    }
  ],
  "proof":183390,
  "previous_hash":"91d2d1296158c7faf58a37ddc152593d"
}
```

```bash
$ curl http://localhost:4567/chain
{
  "chain":[
    {
      "index":1,
      "timestamp":"2018-01-09 22:04:06 +0700",
      "transactions":[],
      "proof":1,
      "previous_hash":100
    },
    {
      "index":2,
      "timestamp":"2018-01-09 22:04:11 +0700",
      "transactions":[
        {
          "sender":"0",
          "recipient":"caedf4a87f7841838061dd7dffca2916",
          "amount":1
        }
      ],
      "proof":94813,
      "previous_hash":"84e609b88e68764ac4546cb807d7cf0e"
    },
    {
      "index":3,
      "timestamp":"2018-01-09 22:06:40 +0700",
      "transactions":[
        {
          "sender":"d4ee26eee15148ee92c6cd394edd974e",
          "recipient":"someone-other-address",
          "amount":5
        },
        {
          "sender":"0",
          "recipient":"caedf4a87f7841838061dd7dffca2916",
          "amount":1
        }
      ],
      "proof":183390,
      "previous_hash":"91d2d1296158c7faf58a37ddc152593d"
    }
  ],
  "length":3
}
```
