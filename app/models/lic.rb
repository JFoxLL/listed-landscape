class Lic < ApplicationRecord
    has_many :number_shareholders
    has_many :size_net_assets
    has_many :share_price_vs_nta, class_name: 'SharePriceVsNta'
    has_many :key_people
    has_many :dividend_histories

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
        data = DividendHistory.where(lic_id: id)
                            .group(:year)
                            .sum(:cash_amount)
                            .sort_by { |year, _amount| year }
                            .last(10) # Get the trailing 10 years
    
        chart_data = data.map do |year, amount|
          [year.to_s, amount]
        end
    
        chart_data
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
