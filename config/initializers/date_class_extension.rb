class Date
    def last_weekday_of_month
        last_weekday = self.end_of_month

        while last_weekday.saturday? || last_weekday.sunday?
            last_weekday -= 1.day
        end

        return last_weekday
    end
end