namespace :db do
    desc "Import number shares data from CSV file"
    task import_number_shares_231214: :environment do
      require 'csv'
  
      # Removing all existing records
      puts "Removing all existing records from the NumberShares db table..."
      NumberShare.destroy_all
      puts "All existing records removed successfully!"
  
      # Inserting new records from csv file into db table  
      filepath = Rails.root.join('db', 'import_data', 'number_shares_231214.csv')
  
      puts "Importing NumberShare data from csv file"
  
      CSV.foreach(filepath, headers: true) do |row|
        next if row['number_shares'].blank? # Skip entry if number_shares is empty
  
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          NumberShare.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            number_shares: row['number_shares'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "NumberShare data imported successfully!"
    end
  end
  