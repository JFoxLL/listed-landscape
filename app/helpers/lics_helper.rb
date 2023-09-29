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
      return "$#{value.round}"
    elsif value < 1_000_000
      return "$#{(value.to_f / 1000).round}K"
    elsif value < 10_000_000
      return "$#{'%.1f' % (value.to_f / 1_000_000)}M"
    else
      return "$#{(value.to_f / 1_000_000).round}M"
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
        # plotOptions: {
        #   series: {
        #     dataLabels: {
        #       enabled: true,
        #       align: 'center',
        #       verticalAlign: 'top',
        #       y: -30,
        #       zIndex: 5,
        #       style: {color: '#d4541b', fontSize: '15px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
        #     }
        #   }
        # }
      }
    }
  end

  def share_price_vs_nta_chart_styling(selected_time_duration, selected_tax_type, lic)
    step_value =  case selected_time_duration.to_i
                  when 1..2 then 1
                  when 3..4 then 3
                  when 5..7 then 6
                  when 8..10 then 12
                  else 1
                  end

    common_chart_styling.deep_merge(library: {
      chart: {
        marginRight: 100
      },
      yAxis: {
        softMin: -10,
        softMax: 10, 
        plotLines: [ 
          { 
            color: '#005454', 
            width: 2, 
            value: lic.share_price_vs_nta_average(selected_time_duration, selected_tax_type),
            dashStyle: 'solid',
            zIndex: 5,
            label: {
              text: "#{selected_time_duration}yr avg: #{lic.share_price_vs_nta_average(selected_time_duration, selected_tax_type).round(1).to_s}%",
              align: 'right',
              y: 4,
              x: 100,
              style: {color: '#005454', fontSize: '14px', fontFamily: 'Georgia'}
            }
          },
        ] 
      },
      xAxis: {
        type: 'datetime',
        tickInterval: step_value,
        labels: {
          format: '{value:%b-%y}'
        }
      },
      tooltip: {
        xDateFormat: '%b-%y'
      },
    })
  end

  

end
