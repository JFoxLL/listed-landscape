class PortfolioHoldingsController < ApplicationController

    def show
        @lic = Lic.find_by!(slug: params[:id])

        # Portfolio Holdings Table
        @portfolio_holdings_display_year_options = @lic.portfolio_holdings_unique_years
        @portfolio_holdings_latest_year = @lic.portfolio_holdings_latest_year
        @portfolio_holdings_display_year = params[:portfolio_holdings_display_year].presence&.to_i || @portfolio_holdings_latest_year
        @portfolio_holdings_table_data = @lic.portfolio_holdings(@portfolio_holdings_display_year)

        respond_to do |format|
            format.html
            format.turbo_stream do
                if params[:portfolio_holdings_display_year]
                    render turbo_stream: turbo_stream.update("portfolio_holdings") do
                        render partial: "shared/portfolio_holdings_table", locals: { lic: @lic, portfolio_holdings_display_year: @portfolio_holdings_display_year }
                    end
                end
            end
        end
    end

end
