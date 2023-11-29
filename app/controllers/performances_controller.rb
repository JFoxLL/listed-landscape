class PerformancesController < ApplicationController

  def index
    @investment_focus_options = Lic.group(:investment_focus).order('count_id desc').count('id').keys

    if params[:investment_focus].present?
        @lics = Lic.includes(:share_price_vs_nta).where(investment_focus: params[:investment_focus]).order(market_cap: :desc)
    else
        @lics = Lic.includes(:share_price_vs_nta).order(market_cap: :desc)
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('performances_index_table', partial: 'performances_index_table', locals: { lics: @lics })
      end
    end


  end

end
