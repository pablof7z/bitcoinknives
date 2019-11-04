class TradeResult
  module STATUS
    Failed = 'failed'.freeze
    Success = 'success'.freeze
  end

  attr_accessor :order_id,
                :status,
                :message,
                :price
end
