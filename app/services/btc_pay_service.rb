require 'bitpay_sdk'

class BtcPayService
  def self.create_invoice(order_id: nil, price_in_btc:, redirect_url:nil)
    client.create_invoice(
      price: price_in_btc,
      currency: 'BTC',
      facade: 'merchant',
      params: {
        orderId: order_id,
        notificationEmail: Rails.application.credentials.config.btcpay[:notification_email],
        redirectURL: redirect_url
      })
  end

  def self.get_invoice(btcpay_id)
    client.get_invoice(id: btcpay_id)
  end

  private

  def self.client
    return @client if @client

    @client = BitPay::SDK::Client.new(
      api_uri: Rails.application.credentials.config.btcpay[:url],
      pem: Rails.application.credentials.config.btcpay[:cert],
      tokens: {'merchant' => Rails.application.credentials.config.btcpay[:merchant_token]}
    )
  end
end
