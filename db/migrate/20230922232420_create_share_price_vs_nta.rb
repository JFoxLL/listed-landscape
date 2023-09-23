class CreateSharePriceVsNta < ActiveRecord::Migration[7.0]
  def change
    create_table :share_price_vs_nta do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.date :month_year
      t.decimal :share_price
      t.decimal :pre_tax_nta
      t.decimal :post_tax_nta
      t.decimal :sp_vs_pre_tax_nta
      t.decimal :sp_vs_post_tax_nta
      t.references :lic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
