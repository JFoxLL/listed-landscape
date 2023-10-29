namespace :db do
    desc "Import dividend history data from CSV file"
    task import_dividend_history_231030: :environment do
      require 'csv'
  
      # Step to remove all existing records
      puts "Removing all existing records from Dividend Histories table..."
      DividendHistory.destroy_all
      puts "All existing records removed successfully!"
  
      filepath = Rails.root.join('db', 'import_data', 'dividend_history_231030.csv')
  
      puts "Importing Dividend History data..."
  
      CSV.foreach(filepath, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          DividendHistory.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            ex_date: Date.parse(row['ex_date']), # Convert to Date object
            payment_date: Date.parse(row['payment_date']), # Convert to Date object
            dividend_type: row['dividend_type'],
            dividend_phase: row['dividend_phase'],
            cash_amount: row['cash_amount'],
            franking_level: row['franking_level'],
            corp_tax_rate: row['corp_tax_rate'],
            franking_credit_amount: row['franking_credit_amount'],
            grossed_up_amount: row['grossed_up_amount'],
            drp_price: row['drp_price'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "Dividend History data imported successfully!"
    end
end
  