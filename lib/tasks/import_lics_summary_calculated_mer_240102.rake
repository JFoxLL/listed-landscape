# This is a one-off import of calculated_mer into the Lics Summary db table

namespace :db do
    desc "Import calculated_mer for LICs from updated CSV file"
    task import_calculated_mer_240103: :environment do
      require 'csv'
  
      csv_file_path = Rails.root.join('db', 'import_data', 'lics_summary_240103.csv')
  
      CSV.foreach(csv_file_path, headers: true) do |row|
        ticker = row['ticker']
        calculated_mer = row['calculated_mer'].to_d # Assuming the values are in decimal format in CSV
  
        lic = Lic.find_by(ticker: ticker)
        if lic
          lic.update(calculated_mer: calculated_mer)
        end
      end
    end
  end
  