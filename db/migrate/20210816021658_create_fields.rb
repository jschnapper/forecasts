class CreateFields < ActiveRecord::Migration[6.1]
  def change
    create_table :fields do |t|
      t.string :name, index: { unique: true }, null: false
      t.string :code, index: { unique: true }, null: true
      t.boolean :default, default: false, null: false # applies to all teams when created
      t.text :description
      t.timestamps
    end
  end
end
