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
  end

  def show
    @lic = Lic.find_by!(slug: params[:id])

    @selected_tax_type = params[:tax_type].presence || 'pre_tax'
    @selected_time_duration = params[:time_duration].presence&.to_i || 10

    @chart_data = @lic.chart_share_price_vs_nta(@selected_time_duration, @selected_tax_type)
  end
  
end

