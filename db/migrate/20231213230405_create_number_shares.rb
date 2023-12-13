class CreateNumberShares < ActiveRecord::Migration[7.1]
  def change
    create_table :number_shares do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year
      t.bigint :number_shares
      t.integer :lic_id

      t.timestamps
    end
  end
end
