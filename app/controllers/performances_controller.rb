class PerformancesController < ApplicationController

  def index
    @investment_focus_options = Lic.group(:investment_focus).order('count_id desc').count('id').keys

    if params[:investment_focus].present?
        @lics = Lic.where(investment_focus: params[:investment_focus]).order(market_cap: :desc)
    else
        @lics = Lic.order(market_cap: :desc)
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('performances_index_table', partial: 'performances_index_table', locals: { lics: @lics })
      end
    end
  end

  def show
    @lic = Lic.find_by!(slug: params[:id])

    # Performance Charts
    @performance_chart_data_5yrs = @lic.chart_performance(5)
    @performance_chart_data_10yrs = @lic.chart_performance(10)
  end

end
