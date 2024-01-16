class SharePriceVsNtasController < ApplicationController

    def index
        @investment_focus_options = Lic.group(:investment_focus).order('count_id desc').count('id').keys

        if params[:investment_focus].present?
            @lics = Lic.includes(:share_price_vs_nta).where(investment_focus: params[:investment_focus]).order(market_cap: :desc)
        else
            @lics = Lic.includes(:share_price_vs_nta).order(market_cap: :desc)
        end

        respond_to do |format|
            format.html
            format.turbo_stream do
              render turbo_stream: turbo_stream.update('share_price_vs_ntas_index_table', partial: 'share_price_vs_ntas_index_table', locals: { lics: @lics })
            end
        end
    end

    def show
        @lic = Lic.find_by!(slug: params[:id])

        # Share Price vs NTA Chart
        @selected_tax_type = params[:tax_type].presence || 'pre_tax'

        if @device_type == 'mobile'
          @selected_time_duration = params[:time_duration].presence&.to_i || 3
        else
          @selected_time_duration = params[:time_duration].presence&.to_i || 10
        end
    
        @chart_data = @lic.chart_share_price_vs_nta(@selected_time_duration, @selected_tax_type)

        
        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end

end