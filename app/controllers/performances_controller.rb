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

    # Performance Chart
    @performance_chart_time_frame_selected = params[:performance_chart_time_frame].presence&.to_i || 10
    @performance_chart_data = @lic.chart_performance(@performance_chart_time_frame_selected)

    respond_to do |format|
      format.html
      format.turbo_stream do
        if params[:performance_chart_time_frame]
          render turbo_stream: turbo_stream.update("chart_performance") do
            render partial: "shared/chart_performance", locals: { lic: @lic, performance_chart_time_frame_selected: @performance_chart_time_frame_selected }
          end
        end
      end
    end
  end

end
