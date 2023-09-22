class Lic < ApplicationRecord
    has_many :number_shareholders
    has_many :size_net_assets

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


    private

    def set_slug
        self.slug = "#{ticker}-#{name}".parameterize
    end

end
