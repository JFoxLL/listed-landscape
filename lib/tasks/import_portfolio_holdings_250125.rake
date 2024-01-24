namespace :db do
    desc "Import portfolio holdings data from CSV file"
    task import_portfolio_holdings_240125: :environment do
      require 'csv'
  
      # Removing all existing records
      puts "Removing all existing records from the PortfolioHoldings db table..."
      PortfolioHolding.destroy_all
      puts "All existing records removed successfully!"
  
      # Inserting new records from csv file into db table
      filepath = Rails.root.join('db', 'import_data', 'portfolio_holdings_240125.csv')
  
      puts "Importing Portfolio Holdings data from csv file"
  
      CSV.foreach(filepath, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          PortfolioHolding.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            ordering_method: row['ordering_method'],
            holding_type: row['holding_type'],
            holding_name: row['holding_name'],
            weight: row['weight'],
            sector: row['sector'],
            industry: row['industry'],
            size: row['size'],
            headquartered: row['headquartered'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "Portfolio Holdings data imported successfully!"
    end
  end
  