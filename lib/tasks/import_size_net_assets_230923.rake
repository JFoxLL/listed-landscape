namespace :db do
    desc "Import Size Net Assets data from CSV"
    task import_size_net_assets: :environment do
      require 'csv'
  
      file_path = Rails.root.join('db', 'import_data', 'size_net_assets_230923.csv')
      CSV.foreach(file_path, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
        if lic
          SizeNetAsset.create(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            size_net_assets: row['size_net_assets'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "Size Net Assets data imported successfully!"
    end
  end
  