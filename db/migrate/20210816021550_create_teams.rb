class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name, index: { unique: true }, null: false
      t.string :slug, index: { unique: true }, null: false
      t.boolean :allow_custom_fields, default: false, null: false # allow members to write in fields for submissions
      t.text :description
      t.timestamps
    end
  end
end
