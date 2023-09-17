class AddSlugToLics < ActiveRecord::Migration[7.0]
  def change
    add_column :lics, :slug, :string
  end
end
