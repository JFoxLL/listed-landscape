class CreateLics < ActiveRecord::Migration[7.0]
  def change
    create_table :lics do |t|
      t.string :ticker
      t.string :name
      t.integer :market_cap
      t.integer :listing_year
      t.date :listing_date
      t.integer :yrs_operating
      t.string :investment_focus
      t.string :portfolio_bias
      t.string :benchmark
      t.string :management_structure
      t.string :investment_manager
      t.string :management_fee
      t.decimal :calculated_mer
      t.string :performance_fee
      t.text :objective
      t.string :logo_filename

      t.timestamps
    end
  end
end
