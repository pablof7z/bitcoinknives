class RulesController < ApplicationController
  before_action :set_rule, only: [:show, :edit, :update, :destroy]
  before_action :load_rule_configs, only: [:new, :edit, :create, :update]
  before_action :authenticate_user!

  # GET /rules
  # GET /rules.json
  def index
    @rules = current_user.rules.decorate
  end

  # GET /rules/1
  # GET /rules/1.json
  def show
  end

  # GET /rules/new
  def new
    @rule = if params[:rule]
      Rule.new(rule_params)
    else
      Rule.new
    end
  end

  # GET /rules/1/edit
  def edit
  end

  # POST /rules
  # POST /rules.json
  def create
    @rule = Rule.new(rule_params)
    @rule.user = current_user

    respond_to do |format|
      if @rule.save
        format.html { redirect_to rules_path, notice: 'Rule was successfully created.' }
        format.json { render :show, status: :created, location: @rule }
      else
        format.html { render :new }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rules/1
  # PATCH/PUT /rules/1.json
  def update
    respond_to do |format|
      if @rule.update(rule_params)
        format.html { redirect_to rules_path, notice: 'Rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @rule }
      else
        format.html { render :edit }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rules/1
  # DELETE /rules/1.json
  def destroy
    @rule.destroy
    respond_to do |format|
      format.html { redirect_to rules_url, notice: 'Rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_rule
    @rule = Rule.friendly.find(params[:id])
  end

  def load_rule_configs
    @formulas = RuleConfigService.formulas_human
    @exchanges = RuleConfigService.exchanges
    @periods = RuleConfigService.periods
  end

  def rule_params
    params.require(:rule).permit(
      :user_id,
      :change_percentage,
      :change_period,
      :formula,
      :base_currency,
      :max_sats_per_trade,
      :max_sats_per_period,
      :max_period_in_secs,
      :enabled,
      :exchange_name,
      :exchange_api_key,
      :exchange_api_secret,
    )
  end
end
