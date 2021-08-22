class CreateMonthlyForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :monthly_forecasts do |t|
      t.date :date, index: { unique: true }, null: false
      t.integer :work_hours
      t.integer :holiday_hours
      t.timestamps
    end
  end
end
