class CreateMonthlyForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :monthly_forecasts do |t|
      t.date :date, index: { unique: true }, null: false
      t.integer :work_hours, default: 0, null: false
      t.integer :holiday_hours, default: 0, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end
  end
end
