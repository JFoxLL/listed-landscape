class CreateNumberShareholders < ActiveRecord::Migration[7.0]
  def change
    create_table :number_shareholders do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year
      t.integer :number_shareholders

      t.timestamps
    end
  end
end
