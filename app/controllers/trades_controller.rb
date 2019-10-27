class TradesController < ApplicationController
  before_action :set_rule

  def index
    @trades = @rule.trades
  end

  def show
    @trade = @rule.trades.where(id: params[:id]).first
    redirect_to rules_path unless @trade
    @skip_navbar = true
  end

  private

  def set_rule
    @rule = current_user.rules.where(slug: params[:rule_id]).first!
    redirect_to rules_path unless @rule
  end
end
