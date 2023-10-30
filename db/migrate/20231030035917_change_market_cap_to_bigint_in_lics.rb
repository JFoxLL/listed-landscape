class ChangeMarketCapToBigintInLics < ActiveRecord::Migration[7.1]
  def change
    change_column :lics, :market_cap, :bigint
  end
end
