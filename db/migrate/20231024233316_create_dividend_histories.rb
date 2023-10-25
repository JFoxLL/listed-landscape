class CreateDividendHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :dividend_histories do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year
      t.date :ex_date
      t.date :payment_date
      t.string :dividend_type
      t.string :dividend_phase
      t.decimal :cash_amount
      t.decimal :franking_level
      t.decimal :corp_tax_rate
      t.decimal :franking_credit_amount
      t.decimal :grossed_up_amount
      t.decimal :drp_price
      t.integer :lic_id

      t.timestamps
    end
  end
end
