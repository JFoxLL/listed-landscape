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

  def number_shareholders_chart_styling
    {
      suffix: "K",
      colors: ["#d4541b"],
      height: "400px", 
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '{point.y}K'
        },
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
        legend: {
          enabled: true,
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '{point.y}K',
              align: 'center',
              verticalAlign: 'top',
              y: -30,
              zIndex: 5,
              style: {color: '#d4541b', fontSize: '14px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: true,
                    format: '{point.y}K',
                    align: 'center',
                    verticalAlign: 'top',
                    y: -30,
                    zIndex: 5,
                    style: {color: '#d4541b', fontSize: '8px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def size_net_assets_b_chart_styling
    {
      prefix: "$",
      suffix: "B",
      thousands: ",",
      colors: ["#d4541b"],
      height: "400px",
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '${point.y}B'
        },
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
        legend: {
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
            enabled: true,
            format: '${point.y}B',
            align: 'center',
            verticalAlign: 'top',
            y: -30,
            zIndex: 5,
            style: {color: '#d4541b', fontSize: '14px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: true,
                    format: '${point.y}B',
                    align: 'center',
                    verticalAlign: 'top',
                    y: -30,
                    zIndex: 5,
                    style: {color: '#d4541b', fontSize: '8px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def size_net_assets_m_chart_styling
    {
      prefix: "$",
      suffix: "M",
      thousands: ",",
      colors: ["#d4541b"],
      height: "400px",
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '${point.y}M'
        },
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
        legend: {
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
            enabled: true,
            format: '${point.y}M',
            align: 'center',
            verticalAlign: 'top',
            y: -30,
            zIndex: 5,
            style: {color: '#d4541b', fontSize: '14px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: true,
                    format: '${point.y}M',
                    align: 'center',
                    verticalAlign: 'top',
                    y: -30,
                    zIndex: 5,
                    style: {color: '#d4541b', fontSize: '8px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def performance_chart_styling
    {
      prefix: "$",
      suffix: "K",
      colors: ["#d4541b", "#005454", "#819462"],
      height: "400px", 
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key:%e %b, %Y}:</b><br>',
          pointFormat: '${point.y}K'
        },
        xAxis: {
          type: 'datetime',
          tickInterval: 365 * 24 * 3600 * 1000, # One year in milliseconds
          dateTimeLabelFormats: {
            year: '%Y'
          },
          labels: {
            format: '{value:%Y}',
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454'
        },
        yAxis: {
          min: 5,
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'},
            format: '{value:,.0f}'
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          enabled: true,
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            lineWidth: 2,
            marker: {
              enabled: false
            },
            dataLabels: {
              enabled: false,
            }
          },
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: false
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def dividend_history_annualised_chart_styling
    {
      prefix: "$",
      colors: ["#d4541b"],
      height: "400px",
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: false
        },
        xAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454',
          title: {
            text: 'Dividend amounts shown are on a per-share basis',
            margin: 20,
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          }
        },
        yAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          enabled: true,
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '${point.y:.2f}',
              align: 'center',
              verticalAlign: 'top',
              y: -30,
              zIndex: 1000,
              style: {color: '#d4541b', fontSize: '14px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true,
                headerFormat: '<b>{point.key}:</b><br>',
                pointFormat: '${point.y:.2f}'
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                title: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: true,
                    format: '${point.y}',
                    align: 'center',
                    verticalAlign: 'top',
                    y: -30,
                    zIndex: 5,
                    style: {color: '#d4541b', fontSize: '8px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def dividend_history_franking_chart_styling
    {
      prefix: "$",
      colors: ["#005454", "#d4541b"],
      height: "400px",
      library: {
        chart: {
          backgroundColor: '#f3eee8'
        },
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '${point.y:.2f}'
        },
        xAxis: {
          labels: {
          style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454',
          title: {
            text: 'Dividend amounts shown are on a per-share basis',
            margin: 20,
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          }
        },
        yAxis: {
          min: 0,
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '${point.y:.2f}',
              align: 'center',
              y: 0,
              zIndex: 5,
              style: {color: '#f3eee8', fontSize: '12px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                title: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: false,
                  }
                }
              },
            }
          }]
        }
      }
    }
  end

  def dividend_history_split_chart_styling
    {
      prefix: "$",
      colors: ["#819462", "#005454", "#d4541b"],
      height: "400px",
      library: {
        chart: {
          backgroundColor: '#f3eee8'
        },
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '${point.y:.2f}'
        },
        xAxis: {
          labels: {
          style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454',
          title: {
            text: 'Dividend amounts shown are on a per-share basis',
            margin: 20,
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          }
        },
        yAxis: {
          min: 0,
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '${point.y:.2f}',
              align: 'center',
              y: 0,
              zIndex: 5,
              style: {color: '#f3eee8', fontSize: '12px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                title: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: false,
                  }
                }
              },
            }
          }]
        }
      }
    }
  end

  def dividend_yield_chart_styling
    {
      suffix: "%",
      colors: ["#d4541b", "#005454"],
      height: "400px",
      library: {
        chart: {
          backgroundColor: '#f3eee8'
        },
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '{point.y}%'
        },
        xAxis: {
          labels: {
          style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454',
          tickInterval: 1,
          title: {
            text: 'The start-of-year share price is used when calculating the yield',
            margin: 20,
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          }
        },
        yAxis: {
          min: 0,
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '{point.y}%',
              align: 'center',
              verticalAlign: 'top',
              y: -30,
              zIndex: 5,
              style: {color: '#757575', fontSize: '12px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          },
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                title: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: true,
                    format: '{point.y}%',
                    align: 'center',
                    verticalAlign: 'top',
                    y: -30,
                    zIndex: 5,
                    style: {color: '#757575', fontSize: '8px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def dividend_comparison_chart_styling
    {
      prefix: "$",
      suffix: "M",
      thousands: ",",
      colors: ["#d4541b", "#005454"],
      height: "400px",
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '${point.y}M'
        },
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
        legend: {
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
            enabled: true,
            format: '{point.y}',
            align: 'center',
            verticalAlign: 'top',
            y: -25,
            zIndex: 5,
            style: {color: '#757575', fontSize: '12px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: true,
                    format: '{point.y}',
                    align: 'center',
                    verticalAlign: 'top',
                    y: -25,
                    zIndex: 5,
                    style: {color: '#757575', fontSize: '8px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def cost_indicator_total_chart_styling
    {
      suffix: "%",
      colors: ["#d4541b"],
      height: "400px", 
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '{point.y:.2f}%'
        },
        xAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454',
          title: {
            text: 'Cost Indicator (%) = Included Costs / Avg Pre-Tax Net Assets',
            margin: 20,
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          }
        },
        yAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          enabled: true,
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '{point.y:.2f}%',
              align: 'center',
              verticalAlign: 'top',
              y: -30,
              zIndex: 5,
              style: {color: '#d4541b', fontSize: '14px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                title: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: true,
                    format: '{point.y:.2f}%',
                    align: 'center',
                    verticalAlign: 'top',
                    y: -30,
                    zIndex: 5,
                    style: {color: '#d4541b', fontSize: '8px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def cost_indicator_split_chart_styling
    {
      suffix: "%",
      colors: ["#819462", "#005454", "#d4541b"],
      height: "400px", 
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '{point.y:.2f}%'
        },
        xAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454',
          title: {
            text: 'Cost Indicator (%) = Included Costs / Avg Pre-Tax Net Assets',
            margin: 20,
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          }
        },
        yAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          enabled: true,
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '{point.y:.2f}%',
              align: 'center',
              y: 0,
              zIndex: 5,
              style: {color: '#f3eee8', fontSize: '12px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                title: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: false,
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def costs_incurred_total_chart_styling
    {
      prefix: "$",
      suffix: "M",
      colors: ["#d4541b"],
      height: "400px", 
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '${point.y}M'
        },
        xAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454',
          title: {
            text: 'Costs = All Costs, excluding Income Tax, Interest & Brokerage.<br>(as defined in the Corporations Act 2021)',
            margin: 20,
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          }
        },
        yAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          enabled: true,
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '{point.y}M',
              align: 'center',
              verticalAlign: 'top',
              y: -30,
              zIndex: 5,
              style: {color: '#d4541b', fontSize: '14px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                title: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: true,
                    format: '{point.y}M',
                    align: 'center',
                    verticalAlign: 'top',
                    y: -30,
                    zIndex: 5,
                    style: {color: '#d4541b', fontSize: '8px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
                  }
                }
              }
            }
          }]
        },
      }
    }
  end

  def costs_incurred_split_chart_styling
    {
      prefix: "$",
      suffix: "M",
      colors: ["#819462", "#005454", "#d4541b"],
      height: "400px", 
      library: {
        chart: {backgroundColor: '#f3eee8'},
        tooltip: {
          enabled: true,
          headerFormat: '<b>{point.key}:</b><br>',
          pointFormat: '{point.y}M'
        },
        xAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454',
          title: {
            text: 'Costs = All Costs, excluding Income Tax, Interest & Brokerage.<br>(as defined in the Corporations Act 2021)',
            margin: 20,
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          }
        },
        yAxis: {
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9'
        },
        legend: {
          enabled: true,
          align: 'center',
          verticalAlign: 'top',
          itemStyle: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
        },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '{point.y}M',
              align: 'center',
              y: 0,
              zIndex: 5,
              style: {color: '#f3eee8', fontSize: '12px', fontFamily: 'Georgia', fontWeight: '500', textOutline: 'none'},
            }
          }
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              tooltip: {
                enabled: true
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                title: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              plotOptions: {
                series: {
                  dataLabels: {
                    enabled: false,
                  }
                }
              }
            }
          }]
        },
      }
    }
  end
  
  
  def share_price_vs_nta_chart_styling(selected_time_duration, selected_tax_type, lic)
    step_value = case selected_time_duration.to_i
                 when 1..2 then 1
                 when 3..4 then 3
                 when 5..7 then 6
                 when 8..10 then 12
                 else 1
                 end
  
    {
      height: "400px",
      colors: ["#d4541b"],
      library: {
        chart: {
          backgroundColor: '#f3eee8',
          marginRight: 100
        },
        title: {
          text: nil
        },
        xAxis: {
          type: 'datetime',
          tickInterval: step_value,
          labels: {
            format: '{value:%b-%y}',
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
          lineColor: '#005454'
        },
        yAxis: {
          softMin: -10,
          softMax: 10,
          labels: {
            style: {color: '#585858', fontSize: '14px', fontFamily: 'Georgia'}
          },
          gridLineColor: '#A9A9A9',
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
            }
          ]
        },
        tooltip: {
          enabled: true,
          xDateFormat: '<b>%b-%y:</b>',
          pointFormat: '{point.y:.1f}%'
        },
        responsive: {
          rules: [{
            condition: {
              maxWidth: 767
            },
            chartOptions: {
              chart: {
                marginRight: 10
              },
              title: {
                text: "--- #{selected_time_duration}yr avg: #{lic.share_price_vs_nta_average(selected_time_duration, selected_tax_type).round(1).to_s}%",
                style: {color: '#005454', fontSize: '12px', fontFamily: 'Georgia', fontWeight: 'bold'},
              },
              xAxis: {
                labels: {
                  style: {fontSize: '10px'}
                }
              },
              yAxis: {
                labels: {
                  style: {fontSize: '10px'}
                },
                plotLines: [
                  {
                    color: '#005454',
                    width: 2,
                    value: lic.share_price_vs_nta_average(selected_time_duration, selected_tax_type),
                    dashStyle: 'dash',
                    zIndex: 5,
                  }
                ]
              }
            }
          }]
        }
      }
    }
  end

end
