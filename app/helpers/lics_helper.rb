module LicsHelper

  def format_market_cap(market_cap)
      if market_cap >= 1_000_000_000
        "#{'$%.1f' % (market_cap / 1_000_000_000.0)}B"
      else
        "#{'$%d' % (market_cap / 1_000_000)}M"
      end
  end

  def format_shares_owned(shares)
    if shares < 10_000
      return number_with_delimiter(shares)
    elsif shares < 1_000_000
      return "#{(shares.to_f / 1000).round}K"
    elsif shares < 10_000_000
      return "#{'%.1f' % (shares.to_f / 1_000_000)}M"
    else
      return "#{(shares.to_f / 1_000_000).round}M"
    end
  end

  def format_share_value(value)
    if value < 1000
      return "~ $#{value.round}"
    elsif value < 1_000_000
      return "~ $#{(value.to_f / 1000).round}K"
    elsif value < 10_000_000
      return "~ $#{'%.1f' % (value.to_f / 1_000_000)}M"
    else
      return "~ $#{(value.to_f / 1_000_000).round}M"
    end
  end

  def common_chart_styling
    {
      height: "400px", 
      colors: ["#d4541b"], 
      library: {
        chart: {backgroundColor: '#f3eee8'},
        xAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454'
        },
        yAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
      }
    }
end



end
