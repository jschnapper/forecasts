class CreateMemberForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :member_forecasts do |t|
      t.references :member, foreign_key: true, null: false
      t.references :team_monthly_forecast, foreign_key: true, null: false
      t.text :notes
      t.jsonb :hours
      t.timestamps
    end

    add_index :member_forecasts, [:team_monthly_forecast_id, :member_id], unique: true, name: "index_member_forecasts_on_team_monthly_forecast_member"
  end
end
