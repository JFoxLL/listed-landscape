module DividendHistoriesHelper

    def dividend_amounts_formatted(div_amount)
        div_amount_str = div_amount.to_s
        num_decimal_places = div_amount_str.split('.').last.size

        if num_decimal_places <= 2
            number_to_currency(div_amount)
        else 
            "$#{div_amount.round(5)}"
        end
    end

end
