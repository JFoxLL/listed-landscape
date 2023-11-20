class CreateAnnualReports < ActiveRecord::Migration[7.1]
  def change
    create_table :annual_reports do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year
      t.string :annual_report_filename
      t.integer :lic_id

      t.timestamps
    end
  end
end
