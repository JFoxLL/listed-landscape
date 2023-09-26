class Lic < ApplicationRecord
    has_many :number_shareholders
    has_many :size_net_assets
    has_many :share_price_vs_nta, class_name: 'SharePriceVsNta'
    has_many :key_people

    before_save :set_slug

    def to_param
        slug
    end

    def chart_number_shareholders
        data = NumberShareholder.where(lic_id: id).order(year: :asc).pluck(:year, :number_shareholders)
        start_year = [data.length - 10, 0].max
        chart_data = [['Year', 'Number of Shareholders']]
        chart_data = data[start_year..-1].map { |entry| [entry[0].to_s, entry[1]] }
        chart_data
    end

    def chart_size_net_assets
        data = SizeNetAsset.where(lic_id: id).order(year: :asc).pluck(:year, :size_net_assets)
        start_year = [data.length - 10, 0].max
        chart_data = [['Year', 'Size (Net Assets)']]
        chart_data = data[start_year..-1].map { |entry| [entry[0].to_s, entry[1]] }
        chart_data
    end

    def chart_share_price_vs_pre_tax_nta
        data = SharePriceVsNta.where(lic_id: id).order(month_year: :asc).pluck(:month_year, :sp_vs_pre_tax_nta)
        start_month = [data.length - 120, 0].max
        chart_data = [['Month', 'Share Price vs Pre-Tax NTA']]
        chart_data = data[start_month..-1].map { |entry| [entry[0].strftime('%b %Y'), entry[1]] }
        chart_data
    end

    def chart_share_price_vs_post_tax_nta
        data = SharePriceVsNta.where(lic_id: id).order(month_year: :asc).pluck(:month_year, :sp_vs_post_tax_nta)
        start_month = [data.length - 120, 0].max
        chart_data = [['Month', 'Share Price vs Post-Tax NTA']]
        chart_data = data[start_month..-1].map { |entry| [entry[0].strftime('%b %Y'), entry[1]] }
        chart_data
    end

    def share_price_vs_pre_tax_nta_average_10yrs
        data = SharePriceVsNta.where(lic_id: id)
                              .order(month_year: :desc)
                              .limit(120)
                              .pluck(:sp_vs_pre_tax_nta)
        return average_calculation(data)
    end

    def share_price_vs_post_tax_nta_average_10yrs
        data = SharePriceVsNta.where(lic_id: id)
                              .order(month_year: :desc)
                              .limit(120)
                              .pluck(:sp_vs_post_tax_nta)
        return average_calculation(data)
    end

    def share_price_vs_pre_tax_nta_average_3yrs
        data = SharePriceVsNta.where(lic_id: id)
                              .order(month_year: :desc)
                              .limit(36)
                              .pluck(:sp_vs_pre_tax_nta)
        return average_calculation(data)
    end

    def share_price_vs_post_tax_nta_average_3yrs
        data = SharePriceVsNta.where(lic_id: id)
                              .order(month_year: :desc)
                              .limit(36)
                              .pluck(:sp_vs_post_tax_nta)
        return average_calculation(data)
    end

    def share_price_vs_pre_tax_nta_average_1yr
        data = SharePriceVsNta.where(lic_id: id)
                              .order(month_year: :desc)
                              .limit(12)
                              .pluck(:sp_vs_pre_tax_nta)
        return average_calculation(data)
    end

    def share_price_vs_post_tax_nta_average_1yr
        data = SharePriceVsNta.where(lic_id: id)
                              .order(month_year: :desc)
                              .limit(12)
                              .pluck(:sp_vs_post_tax_nta)
        return average_calculation(data)
    end

    def share_price_vs_pre_tax_nta_latest_value
        most_recent_data = SharePriceVsNta.where(lic_id: id).order(month_year: :desc).limit(1).pluck(:sp_vs_pre_tax_nta).first
        most_recent_data
    end

    def share_price_vs_post_tax_nta_latest_value
        most_recent_data = SharePriceVsNta.where(lic_id: id).order(month_year: :desc).limit(1).pluck(:sp_vs_post_tax_nta).first
        most_recent_data
    end

    def share_price_vs_nta_latest_month
        most_recent_entry = SharePriceVsNta.where(lic_id: id).order(month_year: :desc).limit(1).first
        most_recent_entry&.month_year&.strftime('%b%y')
    end


    private

    def set_slug
        self.slug = "#{ticker}-#{name}".parameterize
    end

    def average_calculation(data)
        if data.present?
          total_value = data.compact.reduce(0, :+)
          average = total_value / data.length
          return average
        else
          return nil
        end
    end

end
