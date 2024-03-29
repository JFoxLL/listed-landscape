class Lic < ApplicationRecord
    has_many :annual_reports
    has_many :common_questions
    has_many :dividend_comparisons
    has_many :dividend_histories
    has_many :expenses
    has_many :key_people
    has_many :number_shareholders
    has_many :number_shares
    has_many :performances
    has_many :portfolio_holdings
    has_many :share_price_histories
    has_many :share_price_summaries
    has_many :share_price_vs_nta, class_name: 'SharePriceVsNta'
    has_many :size_net_assets

    before_save :set_slug

    def to_param
        slug
    end

    # Used in both the Lics index table, and overview section of Lics show page
    def cost_indicator_most_recent_year
        chart_start_year, latest_year = standard_charts_date_range(id)

        expenses = Expense.where(lic_id: id, expense_category: ['External Management Fees', 'Other Expenses'])
                            .where(year: latest_year)
                            .group(:year)
                            .sum(:expense_amount)
                            .first[1]

        average_pre_tax_nta_per_share = SharePriceVsNta.where(lic_id: id)
                                                        .where(year: latest_year)
                                                        .group(:year)
                                                        .average(:pre_tax_nta)
                                                        .first[1]

        number_shares = NumberShare.where(lic_id: id)
                                    .where(year: latest_year)
                                    .pluck(:number_shares)
                                    .first

        average_pre_tax_nta = average_pre_tax_nta_per_share * number_shares
        
        cost_indicator = ((expenses / average_pre_tax_nta) * 100.0).to_f   
        
        return sprintf("%.2f", cost_indicator)
    end

    def annual_report_links
        ar_records = annual_reports.order(year: :desc).limit(10).pluck(:year, :annual_report_filename).to_h

        ar_base_url = "https://storage.googleapis.com/listed-landscape-app-storage/lic-annual-reports/"

        ar_urls = {}
        ar_records.each do |year, filename|
            ar_full_url = "#{ar_base_url}#{filename}.pdf"
            ar_urls[year] = ar_full_url
        end

        ar_links = ar_urls.map do |year, url|
            "<a href='#{url}' target='_blank'>#{year}</a>"
        end

        return ar_links.join(", ").html_safe
    end

    def key_people_directors
        directors = key_people.where(kp_role_director: 'Yes').where.not(kp_role_chairman: 'Yes')
        chairman = key_people.where(kp_role_chairman: 'Yes')
        [chairman, directors.order(:kp_year_joined)].flatten
    end
    
    def key_people_investment_managers
        investment_managers = key_people.where(kp_role_investmentmanager: 'Yes')
        investment_managers.sort_by(&:kp_year_joined)
    end

    # This method sets the date range for some of the subsequent
    def standard_charts_date_range(lic_id)
        chart_max_display_years = 10

        # Just using the 'Number of Shareholers' metric as a proxy for an annual report data update
        latest_year = NumberShareholder.where(lic_id: lic_id)
                                        .order(year: :desc)
                                        .pluck(:year)
                                        .first

        earliest_records_year = NumberShareholder.where(lic_id: lic_id)
                                                    .order(year: :asc)
                                                    .pluck(:year)
                                                    .first

        chart_start_year = [(latest_year - (chart_max_display_years - 1)), earliest_records_year].max
        
        return chart_start_year, latest_year
    end

    def chart_number_shareholders
        chart_start_year, latest_year = standard_charts_date_range(id)

        num_shareholders_data_hash = NumberShareholder.where(lic_id: id)
                                                        .where(year: chart_start_year..latest_year)
                                                        .order(:year)
                                                        .pluck(:year, :number_shareholders)

        num_shareholders_data_hash_formatted = {}
        
        num_shareholders_data_hash.each do |year, num_s|
            year_str = year.to_s
            
            num_s_formatted = if num_s < 10_000
                (num_s / 1000.0).round(1)
            else
                (num_s / 1000).round
            end

            num_shareholders_data_hash_formatted[year_str] = num_s_formatted      
        end

        num_shareholders = {
            name: "Number of Shareholders",
            data: num_shareholders_data_hash_formatted
        }

        chart_data = []
        chart_data << num_shareholders

        return chart_data
    end

    # This method is used to determine which 'Size (Net Assets)' chart to render
    def max_size
        max_size = SizeNetAsset.where(lic_id: id)
                                        .pluck(:size_net_assets)
                                        .max
        return max_size
    end

    def chart_size_net_assets_b
        chart_start_year, latest_year = standard_charts_date_range(id)
        
        size_data_hash = SizeNetAsset.where(lic_id: id)
                                        .where(year: chart_start_year..latest_year)
                                        .order(:year)
                                        .pluck(:year, :size_net_assets)
                                        .to_h

        size_data_hash_formatted = {}

        size_data_hash.each do |year, size|
            year_str = year.to_s
            size_formatted = (size / 1_000_000_000.0).round(1)
            size_data_hash_formatted[year_str] = size_formatted
        end

        size = {
            name: "Portfolio Size",
            data: size_data_hash_formatted,
        }
        
        chart_data = []
        chart_data << size

        return chart_data
    end

    def chart_size_net_assets_m
        chart_data = []

        size_data_hash = SizeNetAsset.where(lic_id: id)
                                                .order(:year)
                                                .pluck(:year, :size_net_assets)
                                                .to_h
        
        size_data_hash_formatted = {}

        size_data_hash.each do |year, size|
            year_str = year.to_s
            size_formatted = (size / 1_000_000.0).round
            size_data_hash_formatted[year_str] = size_formatted
        end

        size = {
            name: "Portfolio Size",
            data: size_data_hash_formatted,
        }

        chart_data << size

        return chart_data
    end

    def portfolio_holdings_unique_years
        unique_years_array = PortfolioHolding.where(lic_id: id)
                                                .order(year: :desc)
                                                .pluck(:year)
                                                .uniq                                        
        return unique_years_array
    end

    def portfolio_holdings_latest_year
        latest_year = portfolio_holdings_unique_years.first
    end

    def portfolio_holdings_ordering_style(year)
        ordering_style = PortfolioHolding.where(lic_id: id)
                                            .where(year: year)
                                            .pluck(:ordering_method)
                                            .first
        return ordering_style
    end

    def portfolio_holdings(year)
        portfolio_holdings_unordered = PortfolioHolding.where(lic_id: id)
                                                        .where(year: year)
                                                        .where(holding_type: "Holding")

        if portfolio_holdings_ordering_style(year) == "Weight"
            portfolio_holdings_ordered = portfolio_holdings_unordered.order(weight: :desc)
        else
            portfolio_holdings_ordered = portfolio_holdings_unordered.order(:holding_name)
        end

        return portfolio_holdings_ordered
    end

    def portfolio_holdings_cash(year)
        portfolio_holdings_cash = PortfolioHolding.where(lic_id: id)
                                                    .where(year: year)
                                                    .where(holding_type: "Cash")
                                                    .pluck(:weight)
                                                    .first
        return portfolio_holdings_cash
    end

    def chart_performance(chart_duration_years)
        chart_data = []

        #---#
        # Chart Parameters
        starting_amount = 10_000
        number_of_days_in_a_year = 365.25
        days_to_go_back = (chart_duration_years * number_of_days_in_a_year).round
        #---#

        #---#
        # Identifying the chart start date
        earliest_share_price_date = share_price_histories.order(date: :asc).first.date
        latest_share_price_date = share_price_histories.order(date: :desc).first.date
        chart_start_date = [earliest_share_price_date, latest_share_price_date - days_to_go_back.days].max
        #---#

        #---#
        # Extracting the share price data from the chart start date onwards
        # Result is an array of arrays [[date1, share_price1], [date2, share_price2],...]
        share_price_data = share_price_histories.where("date >= ?", chart_start_date)
                                                .order(date: :asc)
                                                .pluck(:date, :share_price)
        #---#

        #---#
        # Extracting the dividend data from the chart start date onwards
        # Result is an array of arrays [[payment_date1, cash_amount1, drp_price1], ...]
        dividend_net_data = dividend_histories.where("payment_date >= ?", chart_start_date)
                                            .order(payment_date: :asc)
                                            .pluck(:payment_date, :cash_amount, :drp_price)
        #---#

        #---#
        # Extracting the dividend+franking data from the chart start date onwards
        # Result is an array of arrays [[payment_date1, grossed_up_amount1, drp_price1], ...]
        dividend_gross_data = dividend_histories.where("payment_date >= ?", chart_start_date)
                                                .order(payment_date: :asc)
                                                .pluck(:payment_date, :grossed_up_amount, :drp_price)
        #---#

        #---#
        # Identifies the starting share price, then calculates number of initial shares
        starting_share_price = share_price_data.first.last
        starting_number_shares = (starting_amount / starting_share_price).round(4)
        #---#

        #---#
        # Creation of 'Share Price Only' data hash
        share_price_only_investment_value_data_hash_daily = share_price_data.map do |date, share_price|
            investment_value = (starting_number_shares * share_price).round(4)
            [date, investment_value]
        end.to_h

        share_price_only_investment_value_data_hash_monthly = {}
        share_price_only_investment_value_data_hash_monthly[share_price_only_investment_value_data_hash_daily.first.first.to_time.to_i * 1000] = 
            (share_price_only_investment_value_data_hash_daily.first.last / 1000).round(1)
        share_price_only_investment_value_data_hash_daily.each do |date, investment_value|
            if date == date.last_weekday_of_month
                share_price_only_investment_value_data_hash_monthly[date.to_time.to_i * 1000] = (investment_value / 1000).round(1)
            end
        end
        #---#

        #---#
        # Creation of 'With Dividends reinvested' data hash
        dividends_net_reinvested_investment_value_data_hash_daily = {}
        dividends_net_reinvested_number_shares = starting_number_shares

        share_price_data.each do |date, share_price|

            dividend_net_data.each do |dividend_record|
                dividend_payment_date, dividend_net_amount, drp_price = dividend_record

                if dividend_payment_date == date
                    number_shares_received = ((dividends_net_reinvested_number_shares * dividend_net_amount) / drp_price).round(4)
                    dividends_net_reinvested_number_shares += number_shares_received

                    dividend_net_data.delete(dividend_record)
                end
            end
        
            dividends_net_reinvested_investment_value = (dividends_net_reinvested_number_shares * share_price).round(4)
            dividends_net_reinvested_investment_value_data_hash_daily[date] = dividends_net_reinvested_investment_value
        end

        dividends_net_reinvested_investment_value_data_hash_monthly = {}
        dividends_net_reinvested_investment_value_data_hash_monthly[dividends_net_reinvested_investment_value_data_hash_daily.first.first.to_time.to_i * 1000] = 
            (dividends_net_reinvested_investment_value_data_hash_daily.first.last / 1000).round(1)
        dividends_net_reinvested_investment_value_data_hash_daily.each do |date, investment_value|
            if date == date.last_weekday_of_month
                dividends_net_reinvested_investment_value_data_hash_monthly[date.to_time.to_i * 1000] = (investment_value / 1000).round(1)
            end
        end
        #---#

        #---#
        # Creation of 'With Dividends & Franking Credits reinvested' data hash
        dividends_gross_reinvested_investment_value_data_hash_daily = {}
        dividends_gross_reinvested_number_shares = starting_number_shares

        share_price_data.each do |date, share_price|

            dividend_gross_data.each do |dividend_record|
                dividend_payment_date, dividend_gross_amount, drp_price = dividend_record

                if dividend_payment_date == date
                    number_shares_received = ((dividends_gross_reinvested_number_shares * dividend_gross_amount) / drp_price).round(4)
                    dividends_gross_reinvested_number_shares += number_shares_received

                    dividend_gross_data.delete(dividend_record)
                end
            end
        
            dividends_gross_reinvested_investment_value = (dividends_gross_reinvested_number_shares * share_price).round(4)
            dividends_gross_reinvested_investment_value_data_hash_daily[date] = dividends_gross_reinvested_investment_value
        end

        dividends_gross_reinvested_investment_value_data_hash_monthly = {}
        dividends_gross_reinvested_investment_value_data_hash_monthly[dividends_gross_reinvested_investment_value_data_hash_daily.first.first.to_time.to_i * 1000] = 
            (dividends_gross_reinvested_investment_value_data_hash_daily.first.last / 1000).round(1)
        dividends_gross_reinvested_investment_value_data_hash_daily.each do |date, investment_value|
            if date == date.last_weekday_of_month
                dividends_gross_reinvested_investment_value_data_hash_monthly[date.to_time.to_i * 1000] = (investment_value / 1000).round(1)
            end
        end
        #---#

        #---#
        # Extracting final investment_value values
        final_value_share_price_only = share_price_only_investment_value_data_hash_monthly.to_a.last[1]
        final_value_dividends_net_reinvested = dividends_net_reinvested_investment_value_data_hash_monthly.to_a.last[1]
        final_value_dividends_gross_reinvested = dividends_gross_reinvested_investment_value_data_hash_monthly.to_a.last[1]

        #---#
        # Calclating CAGR values
        cagr_start_date = share_price_data.first.first
        cagr_end_date = share_price_data.last.first
        cagr_number_years = ((cagr_end_date - cagr_start_date) / number_of_days_in_a_year).round(4)

        cagr_share_price_only = 
            ((share_price_only_investment_value_data_hash_daily.to_a.last[1] /
              share_price_only_investment_value_data_hash_daily.to_a.first[1]) **
              (1 / cagr_number_years) - 1) * 100

        cagr_dividends_net_reinvested = 
            ((dividends_net_reinvested_investment_value_data_hash_daily.to_a.last[1] /
              dividends_net_reinvested_investment_value_data_hash_daily.to_a.first[1]) **
              (1 / cagr_number_years) - 1) *100

        cagr_dividends_gross_reinvested = 
            ((dividends_gross_reinvested_investment_value_data_hash_daily.to_a.last[1] /
              dividends_gross_reinvested_investment_value_data_hash_daily.to_a.first[1]) **
              (1 / cagr_number_years) - 1) *100
        #---#

        #---#
        # Setting up Highcharts data formats
        share_price_only_investment_performance = {
            name: "Share Price Only: #{cagr_share_price_only.round(1)}% p.a",
            data: share_price_only_investment_value_data_hash_monthly
        }
        dividends_net_reinvested_investment_performance = {
            name: "Dividends Reinvested Net: #{cagr_dividends_net_reinvested.round(1)}% p.a",
            data: dividends_net_reinvested_investment_value_data_hash_monthly
        }
        dividends_gross_reinvested_investment_performance = {
            name: "Dividends Reinvested Gross: #{cagr_dividends_gross_reinvested.round(1)}% p.a",
            data: dividends_gross_reinvested_investment_value_data_hash_monthly
        }
        #---#

        #---#
        # Populating the chart_data_array
        chart_data << share_price_only_investment_performance
        chart_data << dividends_net_reinvested_investment_performance
        chart_data << dividends_gross_reinvested_investment_performance
        #---#

        return chart_data
    end

    # This method sets the date range of the subequent Divident related chart methods
    # There is a difference in this date range setting (to the standard) due to the interim/ final dividend scenario
    def dividend_charts_date_range(lic_id)
        chart_max_display_years = 10

        latest_full_year = DividendHistory.where(lic_id: lic_id, dividend_phase: 'Final')
                                            .order(year: :desc)
                                            .pluck(:year)
                                            .first

        earliest_div_records_year = DividendHistory.where(lic_id: lic_id)
                                                    .order(year: :asc)
                                                    .pluck(:year)
                                                    .first

        chart_start_year = [(latest_full_year - (chart_max_display_years - 1)), earliest_div_records_year].max

        return chart_start_year, latest_full_year
    end

    def chart_dividend_history_annualised
        chart_start_year, latest_full_year = dividend_charts_date_range(id)

        total_div_amount_data_hash = DividendHistory.where(lic_id: id)
                                                    .where(year: chart_start_year..latest_full_year)
                                                    .order(:year)
                                                    .group(:year)
                                                    .sum(:cash_amount)
                                                    .transform_values { |value| value.round(2) }

        total_div_amount = {
            name: "Total Annual Cash Dividends",
            data: total_div_amount_data_hash
        }

        chart_data = []
        chart_data << total_div_amount

        return chart_data
    end

    def chart_dividend_history_franking
        chart_start_year, latest_full_year = dividend_charts_date_range(id)
        
        total_div_cash_amount_data_hash = DividendHistory.where(lic_id: id)
                                                            .where(year: chart_start_year..latest_full_year)
                                                            .order(:year)
                                                            .group(:year)
                                                            .sum(:cash_amount)
                                                            .transform_values { |value| value.round(2) }
        
        total_div_credit_amount_data_hash = DividendHistory.where(lic_id: id)
                                                                .where(year: chart_start_year..latest_full_year)
                                                                .order(:year)
                                                                .group(:year)
                                                                .sum(:franking_credit_amount)
                                                                .transform_values { |value| value.round(2) }

        total_div_cash_amount = {
            name: "Total Annual Cash Dividends",
            data: total_div_cash_amount_data_hash
        }

        total_div_credit_amount = {
            name: "Franking Credits",
            data: total_div_credit_amount_data_hash
        }

        chart_data = []
        chart_data << total_div_credit_amount
        chart_data << total_div_cash_amount

        return chart_data
    end

    def chart_dividend_history_split
        chart_start_year, latest_full_year = dividend_charts_date_range(id)

        interim_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Interim')
                                                        .where(year: chart_start_year..latest_full_year)
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(2) }

        final_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Final')
                                                        .where(year: chart_start_year..latest_full_year)
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(2) }

        special_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Special')
                                                        .where(year: chart_start_year..latest_full_year)
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(2) }

        interim_div_amount = {
            name: "Interim Dividend(s)",
            data: interim_div_amount_data_hash
        }

        final_div_amount = {
            name: "Final Dividend",
            data: final_div_amount_data_hash
        }

        special_div_amount = {
            name: "Special Dividend(s)",
            data: special_div_amount_data_hash
        }

        chart_data = []
        chart_data << special_div_amount
        chart_data << final_div_amount
        chart_data << interim_div_amount

        return chart_data                                              
    end

    def chart_dividend_yield
        chart_start_year, latest_full_year = dividend_charts_date_range(id)
        
        div_amount_net_data_hash = DividendHistory.where(lic_id: id)
                                                    .where(year: chart_start_year..latest_full_year)
                                                    .order(:year)
                                                    .group(:year)
                                                    .sum(:cash_amount)
        
        div_amount_gross_data_hash = DividendHistory.where(lic_id: id)
                                                    .where(year: chart_start_year..latest_full_year)
                                                    .order(:year)
                                                    .group(:year)
                                                    .sum(:grossed_up_amount)

        sp_opening_data_hash = SharePriceSummary.where(lic_id: id)
                                                .where(year: chart_start_year..latest_full_year)
                                                .order(:year)
                                                .pluck(:year, :sp_opening)
                                                .to_h
        
        #---#
        div_yield_net_data_hash = {}
        div_amount_net_data_hash.each do |year, div_amount|
            div_yield_net_calc = ((div_amount / sp_opening_data_hash[year]) * 100).round(1)
            year_str = year.to_s
            div_yield_net_data_hash[year_str] = div_yield_net_calc
        end

        div_yield_net = {
            name: "Cash Dividend Yield",
            data: div_yield_net_data_hash
        }
        #---#

        #---#
        div_yield_gross_data_hash = {}
        div_amount_gross_data_hash.each do |year, div_amount|
            div_yield_gross_calc = ((div_amount / sp_opening_data_hash[year]) * 100).round(1)
            year_str = year.to_s
            div_yield_gross_data_hash[year_str] = div_yield_gross_calc
        end

        div_yield_gross = {
            name: "Gross Dividend Yield (including Franking)",
            data: div_yield_gross_data_hash
        }
        #---#

        chart_data = []
        chart_data << div_yield_net
        chart_data << div_yield_gross

        return chart_data
    end

    def chart_dividend_comparison
        chart_start_year, latest_year = standard_charts_date_range(id)
        
        #---#
        div_income_data_hash = DividendComparison.where(lic_id: id)
                                                    .where(year: chart_start_year..latest_year)
                                                    .order(:year)
                                                    .pluck(:year, :total_income)
                                                    .to_h

        div_paid_data_hash = DividendComparison.where(lic_id: id)
                                                .where(year: chart_start_year..latest_year)
                                                .order(:year)
                                                .pluck(:year, :dividends_paid)
                                                .to_h
        #---#
        
        #---#
        div_income_data_hash_formatted = {}
        div_income_data_hash.each do |year, value|
            value_formatted = (value / 1_000_000.0).round
            div_income_data_hash_formatted[year] = value_formatted
        end

        div_paid_data_hash_formatted = {}
        div_paid_data_hash.each do |year, value|
            value_formatted = (value / 1_000_000.0).round
            div_paid_data_hash_formatted[year] = value_formatted
        end
        #---#

        #---#
        div_income = {
            name: "Dividend & Interest Income from Portfolio",
            data: div_income_data_hash_formatted
        }

        div_paid = {
            name: "Dividends Paid to Shareholders",
            data: div_paid_data_hash_formatted
        }
        #---#

        #---#
        chart_data = []
        chart_data << div_income
        chart_data << div_paid
        #---#

        return chart_data
    end

    def chart_cost_indicator_excluding_performance_fees
        chart_start_year, latest_year = standard_charts_date_range(id)

        # Collecting cost values, for the numerator of the calculation
        expenses_excl_perf_fees_data_hash = Expense.where(lic_id: id, expense_category: ['External Management Fees', 'Other Expenses'])
                                                    .where(year: chart_start_year..latest_year)
                                                    .order(:year)
                                                    .group(:year)
                                                    .sum(:expense_amount)

        # Collecting the 'average' Pre-Tax NTA values (prior to multiplying them by the num_shares)
        average_pre_tax_nta_per_share_data_hash = SharePriceVsNta.where(lic_id: id)
                                                    .where(year: chart_start_year..latest_year)
                                                    .order(:year)
                                                    .group(:year)
                                                    .average(:pre_tax_nta)

        # Collecting the weighted average number of shares (in order to multiply be the avg pre-tax NTA per share)
        number_shares_data_hash = NumberShare.where(lic_id: id)
                                                .where(year: chart_start_year..latest_year)
                                                .order(:year)
                                                .pluck(:year, :number_shares)
                                                .to_h
                                                
        # Creating the Average Pre-Tax NTA data hash
        average_pre_tax_nta_data_hash = {}
        average_pre_tax_nta_per_share_data_hash.each do |year, avg_pre_tax_nta_per_share|
            if number_shares_data_hash.has_key?(year)
                average_pre_tax_nta_data_hash[year] = (avg_pre_tax_nta_per_share * number_shares_data_hash[year]).to_f
            end
        end

        # Creating the Cost Indicator data hash
        cost_indicator_excl_perf_fees_data_hash = {}
        average_pre_tax_nta_data_hash.each do |year, avg_pre_tax_nta|
            if expenses_excl_perf_fees_data_hash.has_key?(year)
                cost_indicator_excl_perf_fees_data_hash[year] = ((expenses_excl_perf_fees_data_hash[year] / avg_pre_tax_nta) * 100.0).to_f.round(2) 
            end
        end

        cost_indicator_excl_perf_fees = {
            name: "Cost Indicator - Excluding Performance Fees",
            data: cost_indicator_excl_perf_fees_data_hash
        }

        chart_data = []
        chart_data << cost_indicator_excl_perf_fees

        return chart_data
    end

    def chart_cost_indicator_total
        chart_start_year, latest_year = standard_charts_date_range(id)

        # Collecting cost values, for the numerator of the calculation
        expenses_total_data_hash = Expense.where(lic_id: id, expense_category: ['External Management Fees', 'External Performance Fees', 'Other Expenses'])
                                            .where(year: chart_start_year..latest_year)
                                            .order(:year)
                                            .group(:year)
                                            .sum(:expense_amount)

        # Collecting the 'average' Pre-Tax NTA values (prior to multiplying them by the num_shares)
        average_pre_tax_nta_per_share_data_hash = SharePriceVsNta.where(lic_id: id)
                                                    .where(year: chart_start_year..latest_year)
                                                    .order(:year)
                                                    .group(:year)
                                                    .average(:pre_tax_nta)

        # Collecting the weighted average number of shares (in order to multiply be the avg pre-tax NTA per share)
        number_shares_data_hash = NumberShare.where(lic_id: id)
                                                .where(year: chart_start_year..latest_year)
                                                .order(:year)
                                                .pluck(:year, :number_shares)
                                                .to_h
                                                
        # Creating the Average Pre-Tax NTA data hash
        average_pre_tax_nta_data_hash = {}
        average_pre_tax_nta_per_share_data_hash.each do |year, avg_pre_tax_nta_per_share|
            if number_shares_data_hash.has_key?(year)
                average_pre_tax_nta_data_hash[year] = (avg_pre_tax_nta_per_share * number_shares_data_hash[year]).to_f
            end
        end

        # Creating the Cost Indicator data hash
        cost_indicator_data_hash = {}
        average_pre_tax_nta_data_hash.each do |year, avg_pre_tax_nta|
            if expenses_total_data_hash.has_key?(year)
                cost_indicator_data_hash[year] = ((expenses_total_data_hash[year] / avg_pre_tax_nta) * 100.0).to_f.round(2) 
            end
        end

        cost_indicator = {
            name: "Cost Indicator - Including Performance Fees",
            data: cost_indicator_data_hash
        }

        chart_data = []
        chart_data << cost_indicator

        return chart_data
    end

    def chart_cost_indicator_split
        chart_start_year, latest_year = standard_charts_date_range(id)

        #---#
        # Collecting cost values, for the numerator of the calculations
        expenses_management_fees_data_hash = Expense.where(lic_id: id, expense_category: 'External Management Fees')
                                                    .where(year: chart_start_year..latest_year)
                                                    .order(:year)
                                                    .group(:year)
                                                    .sum(:expense_amount)

        expenses_performance_fees_data_hash = Expense.where(lic_id: id, expense_category: 'External Performance Fees')
                                                        .where(year: chart_start_year..latest_year)
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:expense_amount)

        expenses_other_data_hash = Expense.where(lic_id: id, expense_category: 'Other Expenses')
                                            .where(year: chart_start_year..latest_year)
                                            .order(:year)
                                            .group(:year)
                                            .sum(:expense_amount)
        #---#

        #---#
        # Collecting the 'average' Pre-Tax NTA values (prior to multiplying them by the num_shares)
        average_pre_tax_nta_per_share_data_hash = SharePriceVsNta.where(lic_id: id)
                                                                    .where(year: chart_start_year..latest_year)
                                                                    .order(:year)
                                                                    .group(:year)
                                                                    .average(:pre_tax_nta)

        # Collecting the weighted average number of shares (in order to multiply be the avg pre-tax NTA per share)
        number_shares_data_hash = NumberShare.where(lic_id: id)
                                                .where(year: chart_start_year..latest_year)
                                                .order(:year)
                                                .pluck(:year, :number_shares)
                                                .to_h
        
        # Creating the Average Pre-Tax NTA data hash
        average_pre_tax_nta_data_hash = {}
        average_pre_tax_nta_per_share_data_hash.each do |year, avg_pre_tax_nta_per_share|
            if number_shares_data_hash.has_key?(year)
            average_pre_tax_nta_data_hash[year] = (avg_pre_tax_nta_per_share * number_shares_data_hash[year]).to_f
            end
        end
        #---#

        #---#
        # Creating the Cost Indicator data hashes
        cost_indicator_management_fees_data_hash = {}
        average_pre_tax_nta_data_hash.each do |year, avg_pre_tax_nta|
            if expenses_management_fees_data_hash.has_key?(year)
                cost_indicator_management_fees_data_hash[year] = ((expenses_management_fees_data_hash[year] / avg_pre_tax_nta) * 100.0).to_f.round(2) 
            end
        end 

        cost_indicator_performance_fees_data_hash = {}
        average_pre_tax_nta_data_hash.each do |year, avg_pre_tax_nta|
            if expenses_performance_fees_data_hash.has_key?(year)
                cost_indicator_performance_fees_data_hash[year] = ((expenses_performance_fees_data_hash[year] / avg_pre_tax_nta) * 100.0).to_f.round(2) 
            end
        end 

        cost_indicator_other_data_hash = {}
        average_pre_tax_nta_data_hash.each do |year, avg_pre_tax_nta|
            if expenses_other_data_hash.has_key?(year)
                cost_indicator_other_data_hash[year] = ((expenses_other_data_hash[year] / avg_pre_tax_nta) * 100.0).to_f.round(2) 
            end
        end 
        #---#

        #---#
        # Compiling the chart data
        other_expenses_series_name =    if self.management_structure == 'Internally Managed'
                                            'Internal Management & Operational Costs'
                                        else
                                            'Other Operational Costs'
                                        end

        cost_indicator_management_fees = {
            name: 'External Management Fees',
            data: cost_indicator_management_fees_data_hash
        }

        cost_indicator_performance_fees = {
            name: 'External Performance Fees',
            data: cost_indicator_performance_fees_data_hash
        }

        cost_indicator_other = {
            name: other_expenses_series_name,
            data: cost_indicator_other_data_hash
        }

        chart_data = []
        chart_data << cost_indicator_performance_fees
        chart_data << cost_indicator_management_fees
        chart_data << cost_indicator_other
        
        return chart_data
    end

    def chart_costs_incurred_total
        chart_start_year, latest_year = standard_charts_date_range(id)

        expenses_total_data_hash = Expense.where(lic_id: id, expense_category: ['External Management Fees', 'External Performance Fees', 'Other Expenses'])
                                            .where(year: chart_start_year..latest_year)
                                            .order(:year)
                                            .group(:year)
                                            .sum(:expense_amount)
        
        # Expense values formatted by a private method
        expenses_total_data_hash_formatted = format_expense_values(expenses_total_data_hash)

        expenses_total = {
            name: "Total Costs",
            data: expenses_total_data_hash_formatted
        }

        chart_data = []
        chart_data << expenses_total

        return chart_data
    end

    def chart_costs_incurred_split
        chart_start_year, latest_year = standard_charts_date_range(id)

        expenses_management_fees_data_hash = Expense.where(lic_id: id, expense_category: 'External Management Fees')
                                                    .where(year: chart_start_year..latest_year)
                                                    .order(:year)
                                                    .group(:year)
                                                    .sum(:expense_amount)

        expenses_performance_fees_data_hash = Expense.where(lic_id: id, expense_category: 'External Performance Fees')
                                                        .where(year: chart_start_year..latest_year)
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:expense_amount)

        expenses_other_data_hash = Expense.where(lic_id: id, expense_category: 'Other Expenses')
                                            .where(year: chart_start_year..latest_year)
                                            .order(:year)
                                            .group(:year)
                                            .sum(:expense_amount)

        # Formatting expense values using a private method
        expenses_management_fees_data_hash = format_expense_values(expenses_management_fees_data_hash)
        expenses_performance_fees_data_hash = format_expense_values(expenses_performance_fees_data_hash)
        expenses_other_data_hash = format_expense_values(expenses_other_data_hash)

        other_expenses_series_name =    if self.management_structure == 'Internally Managed'
                                            'Internal Management & Operational Costs'
                                        else
                                            'Other Operational Costs'
                                        end

        expenses_management_fees = {
            name: 'External Management Fees',
            data: expenses_management_fees_data_hash
        }

        expenses_performance_fees = {
            name: 'External Performance Fees',
            data: expenses_performance_fees_data_hash
        }

        expenses_other = {
            name: other_expenses_series_name,
            data: expenses_other_data_hash
        }

        chart_data = []
        chart_data << expenses_performance_fees
        chart_data << expenses_management_fees
        chart_data << expenses_other
                                                    
        return chart_data
    end
  
    def chart_share_price_vs_nta(time_duration_in_years, tax_type)
        records = fetch_records(time_duration_in_years)
    
        chart_data = {}
    
        records.each do |record|
            timestamp = DateTime.parse(record.month_year.to_s).strftime('%s').to_i * 1000
            if tax_type == 'pre_tax'
                chart_data[timestamp] = record.sp_vs_pre_tax_nta
            elsif tax_type == 'post_tax'
                chart_data[timestamp] = record.sp_vs_post_tax_nta
            end
        end
    
        return chart_data
    end

    def share_price_vs_nta_average(time_duration_in_years, tax_type)
        records = fetch_records(time_duration_in_years)

        sum = 0
        records.each do |record|
            sum += tax_type == 'pre_tax' ? record.sp_vs_pre_tax_nta : record.sp_vs_post_tax_nta
        end

        average = sum / records.count
        return average.round(1)
    end

    #---#
    # The following methods are used in the 'Share Price vs NTA' index view
    def sp_vs_nta_latest_record
        latest_entry = share_price_vs_nta.order(month_year: :desc).first

        {
            month_year: latest_entry.month_year,
            share_price: latest_entry.share_price,
            pre_tax_nta: latest_entry.pre_tax_nta,
            post_tax_nta: latest_entry.post_tax_nta,
            sp_vs_pre_tax_nta: latest_entry.sp_vs_pre_tax_nta,
            sp_vs_post_tax_nta: latest_entry.sp_vs_post_tax_nta
        }
    end

    def sp_vs_pre_tax_nta_averages(years, tax_type)
        all_records = share_price_vs_nta.order(month_year: :desc).pluck(tax_type)
        number_months = years * 12
        
        if all_records.length < number_months
            desired_records = all_records
        else
            desired_records = all_records.first(number_months)
        end

        average = (desired_records.sum.to_f / desired_records.count)

        return average.round(0)
    end
    #---#

    #---#
    # The following methods are used in the 'Performance' index view, and Performance Tables (on Lic Show page, and Performance SEO page)
    def performance_last_updated
        most_recent_sp_date = share_price_histories.order(date: :desc).pluck(:date).first
    end

    def performance_cagr_calculation(years, div_type)
        # Parameters
        starting_amount = 10_000
        number_of_days_in_a_year = 365.25
        days_to_go_back = (years * number_of_days_in_a_year).round

        # Identifying the Lic inception date (first day of share price data)
        lic_inception_date = share_price_histories.order(date: :asc).first.date

        # Identifying the calculation start date        
        latest_share_price_date = share_price_histories.order(date: :desc).first.date
        calculation_start_date = latest_share_price_date - days_to_go_back

        # Cagr calculation (a dash if Lic's inception date doesn't cover full time duration)
        if lic_inception_date > calculation_start_date
            "-"
        else
            # Extracting share price data from the calculation start date onwards
            # Result is an array of arrays [[date1, share_price1], [date2, share_price2],...]
            share_price_data = share_price_histories.where("date >= ?", calculation_start_date)
                                                    .order(date: :asc)
                                                    .pluck(:date, :share_price)

            # Extracting dividend data from the calculation start date onwards
            # Result is an array of arrays [[payment_date1, cash_amount1, drp_price1], ...]
            dividend_data = dividend_histories.where("payment_date >= ?", calculation_start_date)
                                                    .order(payment_date: :asc)
                                                    .pluck(:payment_date, div_type, :drp_price)

            # Identifies the starting share price, then calculates the number of initial shares
            starting_share_price = share_price_data.first.last
            starting_number_shares = (starting_amount / starting_share_price).round(4)

            # Calculating the end investment value
            dividends_reinvested_investment_value_data_hash_daily = {}
            dividends_reinvested_number_shares = starting_number_shares

            share_price_data.each do |date, share_price|

                dividend_data.each do |dividend_record|
                    dividend_payment_date, dividend_amount, drp_price = dividend_record

                    if dividend_payment_date == date
                        number_shares_received = ((dividends_reinvested_number_shares * dividend_amount) / drp_price).round(4)
                        dividends_reinvested_number_shares += number_shares_received

                        dividend_data.delete(dividend_record)
                    end
                end

                dividends_reinvested_investment_value = (dividends_reinvested_number_shares * share_price).round(4)
                dividends_reinvested_investment_value_data_hash_daily[date] = dividends_reinvested_investment_value
                
            end
            end_amount = dividends_reinvested_investment_value_data_hash_daily.to_a.last[1]

            cagr_calculation_dividend_reinvested = ((end_amount / starting_amount.to_f) ** (1 / years.to_f) - 1) * 100

            return cagr_calculation_dividend_reinvested.to_f
        end
    end

    def performance_cagr_calculation_rounded_0dp(years, div_type)
        cagr_calculation = performance_cagr_calculation(years, div_type)

        if cagr_calculation.is_a?(Numeric)
            return "#{cagr_calculation.round(0)}%"
        else
            return "-"
        end
    end 
    
    def performance_cagr_calculation_rounded_1dp(years, div_type)
        cagr_calculation = performance_cagr_calculation(years, div_type)

        if cagr_calculation.is_a?(Numeric)

            if cagr_calculation > 20 || cagr_calculation < -10
                return "#{cagr_calculation.round(0)}%"
            else
                return "#{cagr_calculation.round(1)}%"
            end

        else
            return "-"
        end
    end 
    #---#

    #---#
    # The following method is used in the 'Dividend Yields' index view
    def dividend_yield_calculation(year, tax_type)
        check_opening_share_price_present = SharePriceSummary.exists?(lic_id: id, year: year)
        return "-" unless check_opening_share_price_present
        
        check_final_dividend_present = DividendHistory.exists?(lic_id: id, year: year, dividend_phase: 'Final')
        return "-" unless check_final_dividend_present

        dividend_amounts = DividendHistory.where(lic_id: id, year: year)
                                            .sum(tax_type)
                                            .to_f

        opening_share_price = SharePriceSummary.where(lic_id: id, year: year)
                                                .pluck(:sp_opening)
                                                .first
                                                .to_f
        
        dividend_yield = (dividend_amounts / opening_share_price) * 100

        return "#{dividend_yield.round(1)}%"
    end
    #---#

    #---#
    # The following method is used in the Dividend History L3 SEO page
    def dividend_payments_ordered
        div_payments = DividendHistory.where(lic_id: id)
                                        .select(:payment_date, :dividend_phase, :cash_amount, :franking_level)
                                        .order(payment_date: :desc)
        
        return div_payments
    end
    #---#

    #---#
    # The following method is used in the Annual Reports L3 SEO page
    def annual_report_links_l3_seo_page
        ar_records = annual_reports.order(year: :desc).pluck(:year, :annual_report_filename).to_h

        ar_base_url = "https://storage.googleapis.com/listed-landscape-app-storage/lic-annual-reports/"

        ar_urls = {}
        ar_records.each do |year, filename|
            ar_full_url = "#{ar_base_url}#{filename}.pdf"
            ar_urls[year] = ar_full_url
        end

        return ar_urls
    end


    private

    def set_slug
        self.slug = "#{ticker}-#{name}".parameterize
    end

    def fetch_records(time_duration_in_years)
        months = time_duration_in_years * 12
        start_date = months.months.ago
        end_date = Date.today
    
        records = SharePriceVsNta.where(lic_id: self.id)
                                  .where(month_year: start_date..end_date)
    
        return records
    end

    def format_expense_values(expenses_hash)
        expenses_formatted_hash = {}
        expenses_hash.each do |year, value|
            formatted_value =   if value > 10_000_000
                                    (value / 1_000_000.0).round(0)
                                else
                                    (value / 1_000_000.0).round(1)
                                end
            expenses_formatted_hash[year] = formatted_value
        end
        return expenses_formatted_hash
    end
end
