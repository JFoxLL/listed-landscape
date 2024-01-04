class CreatePortfolioHoldings < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolio_holdings do |t|

      t.timestamps
    end
  end
end
