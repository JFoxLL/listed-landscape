class RemoveCalculatedMerFromLics < ActiveRecord::Migration[7.1]
  def change
    remove_column :lics, :calculated_mer, :decimal
  end
end
