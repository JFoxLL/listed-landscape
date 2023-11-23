class SharePriceVsNtasController < ApplicationController

    def index
        @lics = Lic.includes(:share_price_vs_nta).order(market_cap: :desc)
    end

end