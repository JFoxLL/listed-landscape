class Lic < ApplicationRecord
    has_many :number_shareholders

    before_save :set_slug

    def to_param
        slug
    end

    def graph_number_shareholders
        data = NumberShareholder.where(lic_id: id).order(year: :asc).pluck(:year, :number_shareholders)
        
        chart_data = [['Year', 'Number of Shareholders']]
        
        data.each do |entry|
            chart_data << [entry[0].to_s, entry[1]]
        end
        
        chart_data
    end


    private

    def set_slug
        self.slug = "#{ticker}-#{name}".parameterize
    end

end
