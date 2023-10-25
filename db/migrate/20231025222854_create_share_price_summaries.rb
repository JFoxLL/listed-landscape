class CreateSharePriceSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :share_price_summaries do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year
      t.decimal :sp_opening
      t.decimal :sp_closing
      t.decimal :sp_average
      t.integer :lic_id

      t.timestamps
    end
  end
end
