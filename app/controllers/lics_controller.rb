class LicsController < ApplicationController

    def index
        @lics = Lic.order(market_cap: :desc)
    end

    def show
        @lic = Lic.find(params[:id])        
    end

end
