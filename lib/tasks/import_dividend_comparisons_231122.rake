namespace :db do
    desc "Import dividend comparison data from CSV file"
    task import_dividend_comparisons_231122: :environment do
      require 'csv'
  
      # Removing all existing records
      puts "Removing all existing records from the Dividend Comparisons db table..."
      DividendComparison.destroy_all
      puts "All existing records removed successfully!"

      # Inserting new records from csv file into db table  
      filepath = Rails.root.join('db', 'import_data', 'dividend_comparisons_231122.csv')
  
      puts "Importing Dividend Comparison data from csv file"
  
      CSV.foreach(filepath, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          DividendComparison.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            dividend_income: row['dividend_income'],
            distribution_income: row['distribution_income'],
            foreign_income: row['foreign_income'],
            dividends_paid_short: row['dividends_paid_short'],
            interest_income: row['interest_income'],
            interest_paid: row['interest_paid'],
            total_income: row['total_income'],
            dividends_paid: row['dividends_paid'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "Dividend Comparison data imported successfully!"
    end
end
  