class LicsController < ApplicationController

    def index
        @lics = Lic.order(market_cap: :desc)
    end

end
