class CreateDividendComparisons < ActiveRecord::Migration[7.1]
  def change
    create_table :dividend_comparisons do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year
      t.integer :dividend_income
      t.integer :distribution_income
      t.integer :foreign_income
      t.integer :dividends_paid_short
      t.integer :interest_income
      t.integer :interest_paid
      t.integer :total_income
      t.integer :dividends_paid
      t.integer :lic_id

      t.timestamps
    end
  end
end
