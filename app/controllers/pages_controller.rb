class PagesController < ApplicationController
  def index
    @rule = Rule.new
    @formulas = RuleConfigService.formulas
    @periods = RuleConfigService.periods
  end

  def page
    render action: params[:page]
  end
end
