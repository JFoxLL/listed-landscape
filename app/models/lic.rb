class Lic < ApplicationRecord
    has_many :number_shareholders
    has_many :size_net_assets
    has_many :share_price_vs_nta, class_name: 'SharePriceVsNta'
    has_many :key_people
    has_many :dividend_histories
    has_many :share_price_summaries

    before_save :set_slug

    def to_param
        slug
    end

    def chart_number_shareholders
        data = NumberShareholder.where(lic_id: id).order(year: :asc).pluck(:year, :number_shareholders)
        start_year = [data.length - 10, 0].max
        
        chart_data = data[start_year..-1].map do |entry|
          year = entry[0].to_s
          number = entry[1]
      
          formatted_number = if number < 10_000
            (number / 1000.0).round(1)
          else
            (number / 1000).round
          end
          
          [year, formatted_number]
        end
        
        chart_data
    end

    def chart_size_net_assets
        data = SizeNetAsset.where(lic_id: id).order(year: :asc).pluck(:year, :size_net_assets)
        start_year = [data.length - 10, 0].max
        
        chart_data = data[start_year..-1].map do |entry|
          year = entry[0].to_s
          size_net_assets = entry[1]
      
          formatted_size = (size_net_assets / 1_000_000.0).round
          
          [year, formatted_size]
        end
        
        chart_data
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

    def chart_dividend_history
        interim_data = DividendHistory.where(lic_id: id, dividend_phase: 'Interim')
                                      .group(:year)
                                      .sum(:cash_amount)
        
        final_data = DividendHistory.where(lic_id: id, dividend_phase: 'Final')
                                    .group(:year)
                                    .sum(:cash_amount)
        
        special_data = DividendHistory.where(lic_id: id, dividend_phase: 'Special')
                                      .group(:year)
                                      .sum(:cash_amount)
    
        years = (interim_data.keys + final_data.keys + special_data.keys).uniq.sort.last(10)
    
        chart_data = years.map do |year|
          interim = interim_data[year] || 0
          final = final_data[year] || 0
          special = special_data[year] || 0
          total = interim + final + special

    
          {
            year: "#{year}<br><br>$#{total.round(2)}",
            interim: interim,
            final: final,
            special: special,
            total: total
          }
        end
    
        chart_data
    end

    def chart_dividend_yield
        chart_data = []

        #---#
        div_amount_net_data_hash = DividendHistory.where(lic_id: id)
                                                        .group(:year)
                                                        .sum(:cash_amount)
        
        div_amount_gross_data_hash = DividendHistory.where(lic_id: id)
                                                        .group(:year)
                                                        .sum(:grossed_up_amount)

        sp_opening_data_hash = SharePriceSummary.where(lic_id: id)
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
