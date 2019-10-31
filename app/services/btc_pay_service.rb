class BtcPayService
  def self.create_invoice(order_id: nil, price_in_btc:, redirect_url:)
    client.create_invoice(
      price: price_in_btc,
      currency: 'BTC',
      facade: 'merchant',
      params: {
        orderId: order_id,
        notificationEmail: BTCPAY_NOTIFICATION_EMAIL,
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
      api_uri: BTCPAY_URL,
      pem: BTCPAY_CERTIFICATE
    )
  end
end
