namespace :db do
    desc "Import common questions data from CSV file"
    task import_common_questions_231109: :environment do
      require 'csv'
  
      # Step to remove all existing records
      puts "Removing all existing records from CommonQuestion table..."
      CommonQuestion.destroy_all
      puts "All existing records removed successfully!"
  
      filepath = Rails.root.join('db', 'import_data', 'common_questions_231109.csv')
  
      puts "Importing Common Questions data..."
  
      CSV.foreach(filepath, headers: true) do |row|
        lic = Lic.find_by(ticker: row['lic_ticker'])
  
        if lic
          CommonQuestion.create!(
            lic_ticker: row['lic_ticker'],
            lic_name: row['lic_name'],
            lic_id: lic.id,
            q1_q: row['q1_q'],
            q1_a: row['q1_a'],
            q2_q: row['q2_q'],
            q2_a: row['q2_a'],
            q3_q: row['q3_q'],
            q3_a: row['q3_a'],
            q4_q: row['q4_q'],
            q4_a: row['q4_a']
          )
        else
          puts "Lic with ticker #{row['lic_ticker']} not found."
        end
      end
      puts "Common Questions data imported successfully!"
    end
  end
  