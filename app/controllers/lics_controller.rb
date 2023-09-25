class LicsController < ApplicationController
    helper_method :sort_column, :sort_direction
  
    def index
      # Dropdown menu
      @investment_focus_options = Lic.group(:investment_focus).order('count_id desc').count('id').keys
      
      # Filtering logic
      if params[:investment_focus].present?
        @lics = Lic.where(investment_focus: params[:investment_focus])
      else
        @lics = Lic.all
      end
      
      # Sorting logic
      @sort_column = params[:sort_by] || 'market_cap'
      @sort_direction = params[:sort_order] || 'desc'
      @lics = @lics.order(@sort_column => @sort_direction)
    end
  
    def show
      @lic = Lic.find_by!(slug: params[:id])
    end
end
