class Lic < ApplicationRecord
    has_many :number_shareholders
    has_many :size_net_assets
    has_many :share_price_vs_nta, class_name: 'SharePriceVsNta'

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
        if data.present?
            total_discount = data.compact.reduce(0, :+)
            average = total_discount / data.length
            return average
        else
            return nil
        end
    end

    def share_price_vs_post_tax_nta_average_10yrs
        data = SharePriceVsNta.where(lic_id: id)
                              .order(month_year: :desc)
                              .limit(120)
                              .pluck(:sp_vs_post_tax_nta)
        if data.present?
            total_discount = data.compact.reduce(0, :+)
            average = total_discount / data.length
            return average
        else
            return nil
        end
    end


    private

    def set_slug
        self.slug = "#{ticker}-#{name}".parameterize
    end

end
