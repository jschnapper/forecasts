class CreateHolidays < ActiveRecord::Migration[6.1]
  def change
    create_table :holidays do |t|
      t.string :name
      t.date :date, null: false, unique: true
      t.timestamps
    end

    add_index :holidays, :date, unique: true
  end
end
