class LicsController < ApplicationController
  
  def index
    @investment_focus_options = Lic.group(:investment_focus).order('count_id desc').count('id').keys
    
    if params[:investment_focus].present?
      @lics = Lic.where(investment_focus: params[:investment_focus])
    else
      @lics = Lic.all
    end
    
    @sort_column = params[:sort_by].presence || 'market_cap'
    @sort_direction = params[:sort_order].presence || 'desc'
    
    if ['market_cap', 'name', 'ticker', 'listing_year', 'investment_focus', 'calculated_mer'].include?(@sort_column) &&
       ['asc', 'desc'].include?(@sort_direction.downcase)
      @lics = @lics.order(@sort_column => @sort_direction)
    else
      @lics = @lics.order('market_cap' => 'desc')
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('lics_index_table', partial: 'lics_index_table', locals: { lics: @lics })
      end
    end
  end

  def show
    @lic = Lic.find_by!(slug: params[:id])

    # Portfolio Holdings Table
    @portfolio_holdings_display_year_options = @lic.portfolio_holdings_unique_years
    @portfolio_holdings_latest_year = @lic.portfolio_holdings_latest_year
    @portfolio_holdings_display_year = params[:portfolio_holdings_display_year].presence&.to_i || @portfolio_holdings_latest_year
    @portfolio_holdings_table_data = @lic.portfolio_holdings(@portfolio_holdings_display_year)


    # Performance Chart
    @performance_chart_time_frame_selected = params[:performance_chart_time_frame].presence&.to_i || 10
    @performance_chart_data = @lic.chart_performance(@performance_chart_time_frame_selected)


    # Dividend Payments Table
    @dividend_payments_full = @lic.dividend_payments_ordered
    @dividend_payments_limited = @lic.dividend_payments_ordered.first(10)
    @dividend_payments_view_type = params[:dividend_payments_view_type] || "limited"


    # Dividend History Chart
    @dividend_history_view_type = params[:dividend_history_view] || "annualised"


    # Cost Indicator Chart
    @cost_indicator_view_type = params[:cost_indicator_view] || "excluding_performance_fees"


    # Costs Incurred Chart
    @costs_incurred_view_type = params[:costs_incurred_view] || "total"


    # Share Price vs NTA Chart
    @selected_tax_type = params[:tax_type].presence || 'pre_tax'

    if @device_type == 'mobile'
      @selected_time_duration = params[:time_duration].presence&.to_i || 3
    else
      @selected_time_duration = params[:time_duration].presence&.to_i || 10
    end

    @chart_data = @lic.chart_share_price_vs_nta(@selected_time_duration, @selected_tax_type)


    # Common Questions
    @common_questions = @lic.common_questions

    
    # Turbo-stream responses
    respond_to do |format|
      format.html
      format.turbo_stream do
        if params[:portfolio_holdings_display_year]
          render turbo_stream: turbo_stream.update("portfolio_holdings") do
              render partial: "shared/portfolio_holdings_table", locals: { lic: @lic, portfolio_holdings_display_year: @portfolio_holdings_display_year }
          end
        elsif params[:performance_chart_time_frame]
          render turbo_stream: turbo_stream.update("chart_performance") do
            render partial: "shared/chart_performance", locals: { lic: @lic, performance_chart_time_frame_selected: @performance_chart_time_frame_selected }
          end
        elsif params[:dividend_history_view]
          render turbo_stream: turbo_stream.update("dividend_history") do
            render partial: "lics/chart_dividend_history_#{@dividend_history_view_type}"
          end
        elsif params[:cost_indicator_view]
          render turbo_stream: turbo_stream.update("cost_indicator") do
            render partial: "lics/chart_cost_indicator_#{@cost_indicator_view_type}"
          end
        elsif params[:costs_incurred_view]
          render turbo_stream: turbo_stream.update("costs_incurred") do
            render partial: "lics/chart_costs_incurred_#{@costs_incurred_view_type}"
          end
        elsif params[:time_duration] || params[:tax_type]
          render turbo_stream: turbo_stream.update("chart_share_price_vs_nta") do
            render partial: "lics/chart_share_price_vs_nta", locals: { lic: @lic, selected_time_duration: @selected_time_duration, selected_tax_type: @selected_tax_type }
          end
        end
      end
    end
  
  end

end

