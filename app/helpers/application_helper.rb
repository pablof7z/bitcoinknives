module ApplicationHelper
  def sats_to_dollars(sats)
    recent_btc_price = BitcoinPriceChange.where(base_currency: 'USD').last.close_price
    number_to_currency((sats * recent_btc_price) / 1e8)
  end

  def number_to_human(number)
    super(number).downcase
  end
end
