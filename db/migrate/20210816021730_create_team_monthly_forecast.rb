class CreateTeamMonthlyForecast < ActiveRecord::Migration[6.1]
  def change
    create_table :team_monthly_forecasts do |t|
      t.references :monthly_forecast, foreign_key: true, null: false
      t.references :team, foreign_key: true, null: false
      t.boolean :open_for_submissions, default: true, null: false
      t.text :message # message to display on forecast
      t.timestamps
    end

    add_index :team_monthly_forecasts, [:team_id, :monthly_forecast_id], unique: true
  end
end
