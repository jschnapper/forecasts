class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email, index: { unique: true }, null: false
      t.references :team, foreign_key: true
      t.references :role, foreign_key: true
      t.timestamps
    end

    add_index :members, [:last_name, :middle_name, :first_name], unique: true
  end
end
