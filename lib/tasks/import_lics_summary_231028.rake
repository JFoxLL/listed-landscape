# Importing the LICs summary information on 27th Oct, 2023

namespace :db do
    desc "Import LICs data from CSV file"
    task import_lics_summary_231028: :environment do
      require 'csv'
  
      csv_file_path = Rails.root.join('db', 'import_data', 'lics_summary_231028.csv')
  
      CSV.foreach(csv_file_path, headers: true) do |row|
        lic = Lic.find_or_initialize_by(ticker: row['ticker'])
  
        lic_params = {
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
  
        lic.update!(lic_params)
      end
  
      puts "LICs data imported and merged successfully!"
    end
  end
  
  