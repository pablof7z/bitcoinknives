class TradeResult
  module STATUS
    Failed = 'failed'.freeze
    Success = 'success'.freeze
  end

  attr_accessor :order_id,
                :status,
                :message,
                :price

  def initialize(message: nil, status: nil, order_id: nil, price: nil)
    @message = message
    @status = status
    @order_id = order_id
    @price = price
  end
end
