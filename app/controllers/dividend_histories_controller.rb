class DividendHistoriesController < ApplicationController

    def show
        @lic = Lic.find_by!(slug: params[:id])

        # Dividend History Chart
        @dividend_history_view_type = params[:dividend_history_view] || "annualised"

        # Historical Dividend Payments Table
        @dividend_payments = @lic.dividend_payments_ordered
    end

end
