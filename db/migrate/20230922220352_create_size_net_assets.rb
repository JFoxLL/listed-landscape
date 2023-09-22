class CreateSizeNetAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :size_net_assets do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year
      t.integer :size_net_assets
      t.references :lic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
