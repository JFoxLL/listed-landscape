class AddYearToSharePriceVsNta < ActiveRecord::Migration[7.1]
  def change
    add_column :share_price_vs_nta, :year, :integer
  end
end
