class CreateTeamMonthlyForecast < ActiveRecord::Migration[6.1]
  def change
    create_table :team_monthly_forecasts do |t|
      t.references :monthly_forecast, foreign_key: true, null: false
      t.references :team, foreign_key: true, null: false
      t.boolean :open, default: true, null: false
      t.text :message # message to display on forecast
      t.timestamps
    end
  end
end
