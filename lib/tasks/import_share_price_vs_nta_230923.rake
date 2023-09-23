namespace :db do
    desc 'Import Share Price Vs NTA data from CSV'
    task import_share_price_vs_nta: :environment do
      require 'csv'
  
      csv_file_path = 'db/import_data/share_price_vs_nta_230923.csv'
  
      puts "Importing Share Price Vs NTA data..."
  
      CSV.foreach(csv_file_path, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
        if lic
          SharePriceVsNta.create(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            month_year: Date.strptime(row['month_year'], '%b-%y'),
            share_price: row['share_price'],
            pre_tax_nta: row['pre_tax_nta'],
            post_tax_nta: row['post_tax_nta'],
            sp_vs_pre_tax_nta: row['sp_vs_pre_tax_nta'],
            sp_vs_post_tax_nta: row['sp_vs_post_tax_nta'],
            lic: lic
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found. Skipping."
        end
      end
  
      puts "Share Price Vs NTA data imported successfully!"
    end
  end
  
  
  