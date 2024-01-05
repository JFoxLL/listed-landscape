# Updating the market_cap data in the Lics summary spreadsheet
# Need to update the task name (line 6) and the csv filename (line 9)

namespace :db do
    desc "Update market_cap for LICs from updated CSV file"
    task update_market_cap_240105: :environment do
      require 'csv'
  
      csv_file_path = Rails.root.join('db', 'import_data', 'lics_summary_240105.csv')
  
      CSV.foreach(csv_file_path, headers: true) do |row|
        ticker = row['ticker']
        market_cap = row['market_cap'].to_i
  
        lic = Lic.find_by(ticker: ticker)
        if lic
          lic.update(market_cap: market_cap)
        end
      end
    end
  end
  