class ExpensesController < ApplicationController

    def show
        @lic = Lic.find_by!(slug: params[:id])
    end
    
end
