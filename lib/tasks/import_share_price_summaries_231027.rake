namespace :db do
    desc "Import share price summaries data from CSV file"
    task import_share_price_summaries_231027: :environment do
      require 'csv'
  
      # Step to remove all existing records
      puts "Removing all existing records from Share Price Summaries table..."
      SharePriceSummary.destroy_all
      puts "All existing records removed successfully!"
  
      filepath = Rails.root.join('db', 'import_data', 'share_price_summaries_231027.csv')
  
      puts "Importing Share Price Summaries data..."
  
      CSV.foreach(filepath, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          SharePriceSummary.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            sp_opening: row['sp_opening'],
            sp_closing: row['sp_closing'],
            sp_average: row['sp_average'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "Share Price Summaries data imported successfully!"
    end
end
  