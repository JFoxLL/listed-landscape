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

    # Performance Charts
    @performance_chart_data_5yrs = @lic.chart_performance(5)
    @performance_chart_data_10yrs = @lic.chart_performance(10)


    # Dividend History Chart
    @dividend_history_view_type = params[:dividend_history_view] || "annualised"

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
        if params[:dividend_history_view]
          render turbo_stream: turbo_stream.update("dividend_history") do
            render partial: "lics/chart_dividend_history_#{@dividend_history_view_type}"
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

