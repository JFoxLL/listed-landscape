module ApplicationHelper
    def canonical_url
        uri = URI(request.original_url)
        uri.query = nil
        uri.to_s
    end

    def sort_lics_index_table(column, title = nil, current_sort_column, current_sort_direction)
        title ||= column.titleize
        css_class = (column == current_sort_column) ? "current #{current_sort_direction}" : nil
        direction = (column == current_sort_column && current_sort_direction == "asc") ? "desc" : "asc"
        
        # Include the current investment_focus parameter, if any
        link_params = { sort_by: column, sort_order: direction }
        link_params[:investment_focus] = params[:investment_focus] if params[:investment_focus].present?
        
        link_to title, link_params, class: css_class, data: { turbo_frame: "lics_index_table" }
    end
end
