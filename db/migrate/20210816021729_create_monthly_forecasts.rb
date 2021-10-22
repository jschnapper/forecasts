class CreateMonthlyForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :monthly_forecasts do |t|
      t.date :date, index: { unique: true }, null: false
      t.integer :total_hours, default: 0, null: false
      t.integer :holiday_hours, default: 0, null: false
      t.text :message # message to display on forecast
      t.timestamps
    end
  end
end
