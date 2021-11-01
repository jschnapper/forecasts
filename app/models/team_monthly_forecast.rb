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
#  index_team_monthly_forecasts_on_monthly_forecast_id              (monthly_forecast_id)
#  index_team_monthly_forecasts_on_team_id                          (team_id)
#  index_team_monthly_forecasts_on_team_id_and_monthly_forecast_id  (team_id,monthly_forecast_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (monthly_forecast_id => monthly_forecasts.id)
#  fk_rails_...  (team_id => teams.id)
#
class TeamMonthlyForecast < ApplicationRecord
  belongs_to :team
  belongs_to :monthly_forecast
  has_many :member_forecasts, dependent: :destroy

  alias_attribute :open?, :open_for_submissions

  validates :team_id, presence: true, uniqueness: { scope: :monthly_forecast }
  validates :monthly_forecast_id, presence: true

  scope :open_forecasts, -> { where(open_for_submissions: true) }

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
  
  def number_of_submissions
    @number_of_submissions || set_number_of_submissions
  end

  # order team fields association
  #   - alphabetize
  #   - holiday
  #   - pto
  #   - other
  def ordered_team_fields
    @ordered_team_fields || order_team_fields
  end


  private

  def set_number_of_submissions
    member_forecasts.reduce(0) { |num, forecast| forecast&.total_hours.present? && forecast&.total_hours > 0 ? num + 1 : num }
  end

  def active_fields
    team.team_fields.active(monthly_forecast.date)
  end

  def order_team_fields
    special_fields = {
      holiday: nil,
      pto: nil,
      other: nil
    }
    sorted_team_fields = []
    active_fields.each do |team_field|
      if !special_fields.keys.include?(team_field.field.name.downcase.to_sym)
        sorted_team_fields.each do |s_field|
          if s_field.field.name.downcase < team_field.field.name.downcase
            break
          end
        end
        sorted_team_fields << team_field
      else
        special_fields[team_field.field.name.downcase.to_sym] = team_field
      end
    end
    sorted_team_fields << special_fields[:holiday] if special_fields[:holiday]
    sorted_team_fields << special_fields[:pto] if special_fields[:pto]
    sorted_team_fields << special_fields[:other] if special_fields[:other]
    return sorted_team_fields
  end
end
