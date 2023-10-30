class ChangeSizeNetAssetsToBigintInSizeNetAssets < ActiveRecord::Migration[7.1]
  def change
    change_column :size_net_assets, :size_net_assets, :bigint
  end
end
