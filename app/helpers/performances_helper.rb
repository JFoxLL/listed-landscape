module PerformancesHelper

    def performance_table_colour_shading(value)

        numeric_value = value.delete('%').to_f

        if numeric_value < 0
            "negative-performance"
        elsif numeric_value > 6
            "strong-performance"
        else
            "neutral-performance"
        end
    end
    
end
