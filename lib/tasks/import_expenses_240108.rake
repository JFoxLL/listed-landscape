namespace :db do
    desc "Import expense data from CSV file"
    task import_expenses_240108: :environment do
      require 'csv'
  
      # Removing all existing records
      puts "Removing all existing records from the Expenses db table..."
      Expense.destroy_all
      puts "All existing records removed successfully!"
  
      # Inserting new records from csv file into db table  
      filepath = Rails.root.join('db', 'import_data', 'expenses_240108.csv')
  
      puts "Importing Expense data from csv file"
  
      CSV.foreach(filepath, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          Expense.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            year: row['year'],
            expense: row['expense'],
            expense_category: row['expense_category'],
            expense_amount: row['expense_amount'],
            lic_id: lic.id
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "Expense data imported successfully!"
    end
  end
  