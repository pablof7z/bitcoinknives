# 🔪 Bitcoin Knives

Bitcoin Knives is a Ruby on rails app that monitors the price of Bitcoin
and automatically purchases when price moves down X% over Y% period. The amount
it purchases is also configurable, so that it allows to run the following:

* When bitcoin's price goes down 5% over 24 hours buy $percentage-changed x 100,000 sats.
  * If it falls 5% = 500,000
  * If it falls 10% = 10,000,000

Bitcoin Knives uses the user exchange and never has access to funds.

## Supported Exchanges

* Kraken

Want another exchange added? [Send an issue report][issue]

## Running Locally

You can run Bitcoin Knives locally. You just need to:

##### Clone the repo and run it

```
git clone https://github.com/heelhook/bitcoinknives
cd bitcoinknives
bundle install
rails db:migrate
rails s
```

##### Configure your rules

Navigate to [http://localhost:3000/][localhost] and create an account
with the rules you want

##### Run the daemons

Once you have your rules setup you can kill the `rails server` and start
the daemons under the `daemons` directory.

```
rails runner daemons/price_fetcher/main.rb
````

On a different terminal run:

```
rails runner daemons/sat_stacker/main.rb
````

And you'll be on your way to stack 'em sats!

Make sure you keep those daemons running at all times.

## Contributing and supporting

Wanna support the project? Just send a PR or send some sats to

3EzCrenksjXGexpsAFcCc2pyRJaarTxLUw

You can tweet at me at [@pablof7z][twitter]

[issue]: https://github.com/heelhook/bitcoinknives/issues/new
[localhost]: http://localhost:3000/
[twitter]: https://twitter.com/pablof7z
