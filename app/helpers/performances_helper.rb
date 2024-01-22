module PerformancesHelper

    def performance_table_colour_shading(value)

        if value.is_a?(Numeric)

            if value < 0
                "negative-performance"
            elsif value > 6
                "strong-performance"
            else
                "neutral-performance"
            end
        
        end
        
    end
    
end
