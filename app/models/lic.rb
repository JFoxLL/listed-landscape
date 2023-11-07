class Lic < ApplicationRecord
    has_many :number_shareholders
    has_many :size_net_assets
    has_many :share_price_vs_nta, class_name: 'SharePriceVsNta'
    has_many :key_people
    has_many :dividend_histories
    has_many :share_price_summaries
    has_many :common_questions

    before_save :set_slug

    def to_param
        slug
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

    def key_people_directors
        directors = key_people.where(kp_role_director: 'Yes').where.not(kp_role_chairman: 'Yes')
        chairman = key_people.where(kp_role_chairman: 'Yes')
        [chairman, directors.order(:kp_year_joined)].flatten
    end
    
    def key_people_investment_managers
        investment_managers = key_people.where(kp_role_investmentmanager: 'Yes')
        investment_managers.sort_by(&:kp_year_joined)
    end

    def chart_dividend_history_annualised
        chart_data = []

        total_div_amount_data_hash = DividendHistory.where(lic_id: id)
                                                    .order(:year)
                                                    .group(:year)
                                                    .sum(:cash_amount)
                                                    .transform_values { |value| value.round(4) }

        total_div_amount = {
            name: "Total Annual Dividends",
            data: total_div_amount_data_hash
        }                

        chart_data << total_div_amount

        return chart_data
    end

    def chart_dividend_history_split
        chart_data = []

        #---#
        interim_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Interim')
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(4) }

        final_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Final')
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(4) }

        special_div_amount_data_hash = DividendHistory.where(lic_id: id, dividend_phase: 'Special')
                                                        .order(:year)
                                                        .group(:year)
                                                        .sum(:cash_amount)
                                                        .transform_values { |value| value.round(4) }
        #---#

        #---#
        interim_div_amount = {
            name: "Interim",
            data: interim_div_amount_data_hash
        }

        final_div_amount = {
            name: "Final",
            data: final_div_amount_data_hash
        }

        special_div_amount = {
            name: "Special",
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
