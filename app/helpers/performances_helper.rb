module PerformancesHelper

    def performance_table_colour_shading(value)

        if value.is_a?(Numeric)
            value_rounded = value.round(0)

            if value_rounded < 0
                "negative-performance"
            elsif value_rounded > 6
                "strong-performance"
            else
                "neutral-performance"
            end
        
        end
        
    end
    
end
