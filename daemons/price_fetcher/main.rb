require 'rest-client'

$:.unshift File.dirname(__FILE__)

config = YAML.load_file("#{Rails.root}/config/price_fetcher.yml")

@historical_price = {}

def fetch_historical_price(currencies, time)
  result = {}

  currencies.each do |currency|
    url = "https://min-api.cryptocompare.com/data/v2/histohour?fsym=BTC&tsym=#{currency}&limit=1&toTs=#{time}"
    resp = RestClient.get(url)
    data = JSON.parse(resp.body)

    result[currency] = data['Data']['Data'][0]['open']
  end

  result
end

def fetch_current_price(currencies)
  url = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=#{currencies.join(',')}"
  resp = RestClient.get(url)
  JSON.parse(resp.body)
end

loop do
  begin
    currencies = config['base_currencies']
    config['periods'].each do |name, period|
      start_time = eval(period).ago
      start_time_base = start_time.beginning_of_hour.to_i
      @historical_price[name] ||= fetch_historical_price(currencies, start_time_base)
    end

    @current_price = fetch_current_price(currencies)

    @current_price.each do |currency, value|
      config['periods'].each_key do |period_name|
        bpc = BitcoinPriceChange.where(
          base_currency: currency,
          period: period_name
        ).first_or_initialize

        bpc.update(
          open_price: @historical_price[period_name][currency],
          close_price: value,
        )

        PriceChannel.broadcast_to(bpc.period,
          open_price: bpc.open_price,
          close_price: bpc.close_price,
          change_percentage: bpc.change_percentage,
        )
      end
    end
  rescue => e
    puts "Error: #{e}"
  end

  sleep(10)
end
