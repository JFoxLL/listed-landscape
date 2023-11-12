class CreateSharePriceHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :share_price_histories do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :lic_id
      t.date :date
      t.decimal :share_price

      t.timestamps
    end
  end
end
