class CreateDividendYields < ActiveRecord::Migration[7.1]
  def change
    create_table :dividend_yields do |t|

      t.timestamps
    end
  end
end
