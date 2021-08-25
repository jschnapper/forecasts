class CreateFields < ActiveRecord::Migration[6.1]
  def change
    create_table :fields do |t|
      t.string :name, index: { unique: true }, null: false
      t.string :code, index: { unique: true }, null: true
      t.text :description
      t.timestamps
    end
  end
end
