class SharePriceVsNtasController < ApplicationController

    def index
        @share_price_vs_ntas = SharePriceVsNta.all
    end

end
