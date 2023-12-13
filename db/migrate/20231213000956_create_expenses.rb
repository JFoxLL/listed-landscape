class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year
      t.string :expense
      t.string :expense_category
      t.integer :expense_amount
      t.integer :lic_id

      t.timestamps
    end
  end
end
