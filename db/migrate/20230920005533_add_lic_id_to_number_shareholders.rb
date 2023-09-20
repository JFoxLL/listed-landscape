class AddLicIdToNumberShareholders < ActiveRecord::Migration[7.0]
  def change
    add_column :number_shareholders, :lic_id, :integer
  end
end
