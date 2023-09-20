namespace :db do
    desc "Import number of shareholders data from CSV file"
    task import_number_shareholders: :environment do
      require 'csv'
  
      filepath = Rails.root.join('db', 'import_data', 'number_shareholders_230920.csv')
  
      CSV.foreach(filepath, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          NumberShareholder.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            number_shareholders: row['number_shareholders'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
    end
end