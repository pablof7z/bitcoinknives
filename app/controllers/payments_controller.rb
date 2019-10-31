class PaymentsController < ApplicationController
  def new
    @invoice = Invoice.create!(
      user: current_user,
      amount: 0.0012,
      currency: 'BTC',
    )

    btcpay_invoice = BtcPayService.create_invoice(
      order_id: @invoice.slug,
      price_in_btc: @invoice.amount,
      redirect_url: payment_url(@invoice),
    )

    @invoice.update!(btcpay_invoice_id: btcpay_invoice['id'])

    redirect_to btcpay_invoice['url']
  end

  def show
    @invoice = current_user.invoices.where(slug: params[:id]).first!

    @btcpay_invoice = BtcPayService.get_invoice(@invoice.btcpay_invoice_id)
    @invoice.update(status: @btcpay_invoice['status'])

    case @btcpay_invoice['status']
    when 'new' then redirect_to @btcpay_invoice['url']
    when 'paid', 'complete'
      current_user.update(upgraded: true)
    when 'expired'
      flash[:danger] = "Looks like the payment has expired. Create a new order below."
      redirect_to rules_path('upgrade-modal' => true)
    else
      Rails.logger.error "Unhandled btcpay invoice status: #{@btcpay_invoice['status']}"
      Raven.capture_message("Unhandled btcpay invoice status: #{@btcpay_invoice['status']}", extra: {btcpay_invoice: @btcpay_invoice})

      flash[:alert] = "Hmmm, something weird happened. We're looking into it!"
      redirect_to rules_path
    end
  end
end
