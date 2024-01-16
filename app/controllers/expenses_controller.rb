class ExpensesController < ApplicationController

    def show
        @lic = Lic.find_by!(slug: params[:id])

        # Cost Indicator Chart
        @cost_indicator_view_type = params[:cost_indicator_view] || "excluding_performance_fees"

        # Costs Incurred Chart
        @costs_incurred_view_type = params[:costs_incurred_view] || "total"

        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end
    
end
