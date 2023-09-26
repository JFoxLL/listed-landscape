require 'csv'

namespace :db do
    desc 'Import key people data from CSV file'
    task import_key_people: :environment do
  
      # Read the file into a string
      original_content = File.read("db/import_data/key_people_230926.csv", encoding: "UTF-8")
  
      # Remove invalid UTF-8 characters
      cleaned_content = original_content.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  
      # Write the cleaned content to a new file
      File.open("db/import_data/key_people_230926_cleaned.csv", "w:UTF-8") { |file| file.write(cleaned_content) }
  
      puts "Importing key people..."
      CSV.foreach("db/import_data/key_people_230926_cleaned.csv", headers: true) do |row|
        KeyPerson.create!(
          lic_ticker: row['lic_ticker'],
          lic_name: row['lic_name'],
          year_updated: row['year_updated'],
          kp_name: row['kp_name'],
          kp_year_joined: row['kp_year_joined'],
          kp_role_chairman: row['kp_role_chairman'],
          kp_role_director: row['kp_role_director'],
          kp_role_investmentmanager: row['kp_role_investmentmanager'],
          kp_role_title: row['kp_role_title'],
          kp_bio: row['kp_bio'],
          kp_shares_owned: row['kp_shares_owned'].presence,
          share_price_eoy: row['share_price_eoy'].presence,
          kp_share_value: row['kp_share_value'].presence,
          kp_image_saved: row['kp_image_saved'],
          kp_image_file_name: row['kp_image_file_name'],
          lic_id: Lic.find_by(ticker: row['lic_ticker']).id
        )
      end
  
      puts "Importing done!"
    end
end
  