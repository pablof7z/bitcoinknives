class PagesController < ApplicationController
  def index
    @rule = Rule.new
    @formulas = RuleConfigService.formulas
  end

  def page
    render action: params[:page]
  end
end
