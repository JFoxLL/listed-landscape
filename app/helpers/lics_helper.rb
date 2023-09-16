module LicsHelper

    def format_market_cap(market_cap)
        if market_cap >= 1_000_000_000
          "#{'$%.1f' % (market_cap / 1_000_000_000.0)}B"
        else
          "#{'$%d' % (market_cap / 1_000_000)}M"
        end
    end

end
