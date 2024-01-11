class DividendHistoriesController < ApplicationController

    def show
        @lic = Lic.find_by!(slug: params[:id])

        # Dividend Payments Table
        @dividend_payments_full = @lic.dividend_payments_ordered
        @dividend_payments_limited = @lic.dividend_payments_ordered.first(10)
        @dividend_payments_view_type = params[:dividend_payments_view_type] || "limited"

        # Dividend History Chart
        @dividend_history_view_type = params[:dividend_history_view] || "annualised"

        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end

end
