class CreateKeyPeople < ActiveRecord::Migration[7.0]
  def change
    create_table :key_people do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :year_updated
      t.string :kp_name
      t.integer :kp_year_joined
      t.string :kp_role_chairman
      t.string :kp_role_director
      t.string :kp_role_investmentmanager
      t.string :kp_role_title
      t.text :kp_bio
      t.integer :kp_shares_owned
      t.decimal :share_price_eoy
      t.decimal :kp_share_value
      t.string :kp_image_saved
      t.string :kp_image_file_name
      t.references :lic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
