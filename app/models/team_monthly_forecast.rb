# == Schema Information
#
# Table name: team_monthly_forecasts
#
#  id                   :bigint           not null, primary key
#  message              :text
#  open_for_submissions :boolean          default(TRUE), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  monthly_forecast_id  :bigint           not null
#  team_id              :bigint           not null
#
# Indexes
#
#  index_team_monthly_forecasts_on_monthly_forecast_id  (monthly_forecast_id)
#  index_team_monthly_forecasts_on_team_id              (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (monthly_forecast_id => monthly_forecasts.id)
#  fk_rails_...  (team_id => teams.id)
#
class TeamMonthlyForecast < ApplicationRecord
  belongs_to :team
  belongs_to :monthly_forecast

  alias_attribute :open?, :open_for_submissions

  validates :team_id, presence: true, uniqueness: { scope: :monthly_forecast }
  validates :monthly_forecast_id, presence: true

  scope :open_forecasts, -> { where(open: true) }

  # delegate methods to monthly forecast
  # for monthly forecast info
  delegate :friendly_name, 
           :friendly_date, 
           :month_name, 
           :year, 
           :date,
           :total_hours,
           :holiday_hours,
           :has_holidays?,
           to: :monthly_forecast
end
