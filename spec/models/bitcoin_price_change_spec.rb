require 'rails_helper'

describe "BitcoinPriceChange" do
  subject { BitcoinPriceChange.new }

  describe '.change_percentage' do
    it 'calculates price change going down' do
      subject.period = '24 hours'
      subject.open_price = 100
      subject.close_price = 50
      subject.save!

      expect(subject.change_percentage).to eq(-50.0)
    end

    it 'calculates price change going up' do
      subject.period = '24 hours'
      subject.open_price = 50
      subject.close_price = 100
      subject.save!

      expect(subject.change_percentage).to eq(100)
    end
  end
end

