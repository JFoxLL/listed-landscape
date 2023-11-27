class SharePriceVsNtasController < ApplicationController
    before_action :set_device_type

    def index
        @lics = Lic.includes(:share_price_vs_nta).order(market_cap: :desc)
    end

end