class CreateMemberForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :member_forecasts do |t|
      t.references :member, foreign_key: true
      t.references :team, foreign_key: true
      t.references :monthly_forecast, foreign_key: true
      t.jsonb :hours
      t.timestamps
    end

    add_index :member_forecasts, [:monthly_forecast_id, :member_id, :team_id], unique: true, name: "index_member_forecasts_on_monthly_forecast_member_and_team"
  end
end
