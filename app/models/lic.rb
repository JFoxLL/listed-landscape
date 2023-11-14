class Lic < ApplicationRecord
    has_many :number_shareholders
    has_many :size_net_assets
    has_many :share_price_vs_nta, class_name: 'SharePriceVsNta'
    has_many :key_people
    has_many :dividend_histories
    has_many :share_price_summaries
    has_many :share_price_histories
    has_many :common_questions

    before_save :set_slug

    def to_param
        slug
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

    def chart_number_shareholders
        chart_data = []

        num_shareholders_data_hash = NumberShareholder.where(lic_id: id)
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

        chart_data << num_shareholders

        return chart_data
    end

    # Used to determin which 'Size (Net Assets)' chart to render
    def max_size
        max_size = SizeNetAsset.where(lic_id: id)
                                        .pluck(:size_net_assets)
                                        .max
        return max_size
    end

    def chart_size_net_assets_b
        chart_data = []

        size_data_hash = SizeNetAsset.where(lic_id: id)
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
            name: "Size (Net Assets)",
            data: size_data_hash_formatted,
        }

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
            name: "Size (Net Assets)",
            data: size_data_hash_formatted,
        }

        chart_data << size

        return chart_data
    end

    def chart_performance
        chart_data = []

        #---#
        # Chart Parameters
        starting_amount = 10_000
        chart_duration_years = 5  # Just static 5 yrs for now, intend to change
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
        dividend_data = dividend_histories.where("payment_date >= ?", chart_start_date)
                                            .order(payment_date: :asc)
                                            .pluck(:payment_date, :cash_amount, :drp_price)
        #---#

        #---#
        # Identifies the starting share price, then calculates number of initial shares
        starting_share_price = share_price_data.first.last
        starting_number_shares = (starting_amount / starting_share_price).round(2)
        #---#

        #---#
        # Creation of 'Share Price Only' data hash
        share_price_only_investment_value_data_hash = share_price_data.map do |date, share_price|
            investment_value = starting_number_shares * share_price
            [date.to_time.to_i * 1000, investment_value.round]
        end.to_h
        #---#

        #---#
        # Creation of 'With Dividends Invested' data hash
        divs_reinvested_investment_value_data_hash = {}
        current_number_shares = starting_number_shares

        share_price_data.each do |date, share_price|

            dividend_data.each do |dividend_record|
                dividend_payment_date, dividend_cash_amount, drp_price = dividend_record

                if dividend_payment_date == date
                    number_shares_received = (current_number_shares * dividend_cash_amount) / drp_price
                    current_number_shares += number_shares_received

                    dividend_data.delete(dividend_record)
                end
            end
        
            investment_value = current_number_shares * share_price
            divs_reinvested_investment_value_data_hash[date.to_time.to_i * 1000] = investment_value.round
        end
        #---#

        #---#
        # Setting up Highcharts data formats
        share_price_only_investment_performance = {
            name: "Performance - Share Price Only",
            data: share_price_only_investment_value_data_hash
        }
        divs_reinvested_investment_performance = {
            name: "Performance - With Dividends Reinvested",
            data: divs_reinvested_investment_value_data_hash
        }
        #---#

        #---#
        # Populating the chart_data_array
        chart_data << share_price_only_investment_performance
        chart_data << divs_reinvested_investment_performance
        #---#

        return chart_data
    end

    def chart_dividend_history_annualised
        chart_data = []

        total_div_amount_data_hash = DividendHistory.where(lic_id: id)
                                                    .order(:year)
                                                    .group(:year)
                                                    .sum(:cash_amount)
                                                    .transform_values { |value| value.round(2) }

        total_div_amount = {
            name: "Total Annual Cash Dividends",
            data: total_div_amount_data_hash
        }                

        chart_data << total_div_amount

        return chart_data
    end

    def chart_dividend_history_franking
        chart_data = []

        #---#
        total_div_cash_amount_data_hash = DividendHistory.where(lic_id: id)
                                                            .order(:year)
                                                            .group(:year)
                                                            .sum(:cash_amount)
                                                            .transform_values { |value| value.round(2) }
        
        total_div_credit_amount_data_hash = DividendHistory.where(lic_id: id)
                                                                .order(:year)
                                                                .group(:year)
                                                                .sum(:franking_credit_amount)
                                                                .transform_values { |value| value.round(2) }
        #---#

        #---#
        total_div_cash_amount = {
            name: "Total Annual Cash Dividends",
            data: total_div_cash_amount_data_hash
        }

        total_div_credit_amount = {
            name: "Franking Credits",
            data: total_div_credit_amount_data_hash
        }
        #---#

        #---#
        chart_data << total_div_credit_amount
        chart_data << total_div_cash_amount
        #---#

        return chart_data
    end

    def chart_dividend_history_split
        chart_data = []

        #---#
        interim_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Interim')
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(2) }

        final_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Final')
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(2) }

        special_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Special')
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(2) }
        #---#

        #---#
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
        #---#

        #---#
        chart_data << special_div_amount
        chart_data << final_div_amount
        chart_data << interim_div_amount
        #---#

        return chart_data                                              
    end

    def chart_dividend_yield
        chart_data = []

        #---#
        div_amount_net_data_hash = DividendHistory.where(lic_id: id)
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
        
        div_amount_gross_data_hash = DividendHistory.where(lic_id: id)
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:grossed_up_amount)

        sp_opening_data_hash = SharePriceSummary.where(lic_id: id)
                                                        .order(:year)
                                                        .pluck(:year, :sp_opening)
                                                        .to_h
        #---#
        
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

        #---#
        chart_data << div_yield_net
        chart_data << div_yield_gross
        #---#

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

end
