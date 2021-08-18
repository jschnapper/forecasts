class CreateHolidays < ActiveRecord::Migration[6.1]
  def change
    create_table :holidays do |t|
      t.string :name
      t.date :date
      t.references :monthly_forecast, foreign_key: true
      t.timestamps
    end
  end
end
