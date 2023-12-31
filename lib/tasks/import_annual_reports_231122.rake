namespace :db do
    desc "Import annual reports data from CSV file"
    task import_annual_reports_231122: :environment do
      require 'csv'

      # Removing all existing records
      puts "Removing all exisiting records from Annual Reports table"
      AnnualReport.destroy_all
      puts "All exisitng records rmeoved successfully"
  
      # Filepath to the CSV file
      filepath = Rails.root.join('db', 'import_data', 'annual_reports_231122.csv')

      # Importing records from csv file  
      puts "Importing Annual Reports data..."
  
      CSV.foreach(filepath, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          AnnualReport.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            annual_report_filename: row['annual_report_filename'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "Annual Reports data imported successfully!"
    end
  end
  