class AddCalculatedMerToLics < ActiveRecord::Migration[7.1]
  def change
    add_column :lics, :calculated_mer, :decimal
  end
end
