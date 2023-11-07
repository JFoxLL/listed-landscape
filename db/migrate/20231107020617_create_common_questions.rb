class CreateCommonQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :common_questions do |t|
      t.string :lic_ticker
      t.string :lic_name
      t.integer :lic_id
      t.text :q1_q
      t.text :q1_a
      t.text :q2_q
      t.text :q2_a
      t.text :q3_q
      t.text :q3_a
      t.text :q4_q
      t.text :q4_a

      t.timestamps
    end
  end
end
