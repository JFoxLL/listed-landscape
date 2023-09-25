class LicsController < ApplicationController

    def index
        sort_by = params[:sort_by] || 'market_cap'
        sort_order = params[:sort_order] || 'desc'
        @lics = Lic.order("#{sort_by} #{sort_order}")
    end

    def show
        @lic = Lic.find_by!(slug: params[:id])        
    end

end
