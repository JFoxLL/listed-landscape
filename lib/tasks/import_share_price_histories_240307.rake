namespace :db do
    desc "Import Share Price Histories from CSV file"
    task import_share_price_histories_240307: :environment do
      require 'csv'
  
      filepath = Rails.root.join('db', 'import_data', 'share_price_histories_240307.csv')
      puts "Importing Share Price History data..."
  
      CSV.foreach(filepath, headers: true) do |row|
        # Convert date from yyyy-mm-dd format
        raw_date = row['Date']
        begin
          formatted_date = Date.parse(raw_date)
        rescue ArgumentError
          puts "Invalid date format: #{raw_date}"
          next
        end
        
        # Iterate through each LIC's share price in the row
        row.to_h.except('Date').each do |lic_ticker, share_price|
          next if share_price.blank?
          
          lic = Lic.find_by(ticker: lic_ticker)
          next unless lic
  
          # Skip if the record already exists
          next if SharePriceHistory.exists?(lic_id: lic.id, date: formatted_date)
  
          SharePriceHistory.create!(
            lic_ticker: lic.ticker,
            lic_name: lic.name,
            lic_id: lic.id,
            date: formatted_date,
            share_price: share_price
          )
        end
      end
    
      puts "Share Price History data imported successfully!"
    end
  end
  