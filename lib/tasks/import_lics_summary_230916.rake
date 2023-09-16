# Importing the LICs summary information on 16th Sep, 2023

namespace :db do
    desc "Import LICs data from CSV file"
    task import_lics: :environment do
      require 'csv'
  
      csv_file_path = Rails.root.join('db', 'import_data', 'lics_summary_import_230916.csv')
  
      CSV.foreach(csv_file_path, headers: true) do |row|
        lic_params = {
          ticker: row['ticker'],
          name: row['name'],
          market_cap: row['market_cap'],
          listing_year: row['listing_year'],
          listing_date: row['listing_date'],
          yrs_operating: row['yrs_operating'],
          investment_focus: row['investment_focus'],
          portfolio_bias: row['portfolio_bias'],
          benchmark: row['benchmark'],
          management_structure: row['management_structure'],
          investment_manager: row['investment_manager'],
          management_fee: row['management_fee'],
          calculated_mer: row['calculated_mer'],
          performance_fee: row['performance_fee'],
          objective: row['objective'],
          logo_filename: row['logo_filename']
        }
  
        Lic.create!(lic_params)
      end
    end
end
  