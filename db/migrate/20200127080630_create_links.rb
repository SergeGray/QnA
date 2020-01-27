class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.references :linkable, null: false, polymorphic: true

      t.timestamps
    end
  end
end
