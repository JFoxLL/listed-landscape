class AddCustomFieldsToPortfolioHoldings < ActiveRecord::Migration[7.1]
  def change
    add_column :portfolio_holdings, :lic_ticker, :string
    add_column :portfolio_holdings, :lic_name, :string
    add_column :portfolio_holdings, :year, :integer
    add_column :portfolio_holdings, :ordering_method, :string
    add_column :portfolio_holdings, :holding_type, :string
    add_column :portfolio_holdings, :holding_name, :string
    add_column :portfolio_holdings, :weight, :decimal
    add_column :portfolio_holdings, :sector, :string
    add_column :portfolio_holdings, :industry, :string
    add_column :portfolio_holdings, :size, :string
    add_column :portfolio_holdings, :headquartered, :string
    add_column :portfolio_holdings, :lic_id, :integer
  end
end
