# Updating the market_cap data from the import earlier today (16th Sep, 2023)
# Import spreadsheet was in currency format, not integer. Resolved this.

namespace :db do
    desc "Update market_cap for LICs from updated CSV file"
    task update_market_cap: :environment do
      require 'csv'
  
      csv_file_path = Rails.root.join('db', 'import_data', 'lics_summary_import_230916.csv')
  
      CSV.foreach(csv_file_path, headers: true) do |row|
        ticker = row['ticker']
        market_cap = row['market_cap'].to_i # Assume it's an integer in the updated file
  
        lic = Lic.find_by(ticker: ticker)
        if lic
          lic.update(market_cap: market_cap)
        end
      end
    end
  end
  