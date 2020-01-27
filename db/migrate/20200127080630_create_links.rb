class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
